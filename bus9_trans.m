function[val] = bus9_trans()
addpath('Transient Stability')
%             From  to  rkm     xkm     bkm/2   tap
Datos.Lineas = [1   4   0.0000  0.0576  0.0000  0
                2   7   0.0000  0.0625  0.0000  0
                3   9   0.0000  0.0586  0.0000  0
                4   5   0.0100  0.0850  0.0880  0
                4   6   0.0170  0.0920  0.0790  0
                5   7   0.0320  0.1610  0.1530  0
                6   9   0.0390  0.1700  0.1790  0
                7   8   0.0085  0.0720  0.0745  0
                8   9   0.0119  0.1008  0.1045  0];
Datos.Gen = [   1  NaN   1.040  0   0.0608   0    0  23.64 0 0 0 0
                2  1.63  1.025  0   0.1198   0    0   6.80 0 0 0 0
                3  0.85  1.025  0   0.1813   0    0   3.01 0 0 0 0 ];  % corregir las inductancias
% nodo P Q
Datos.Cargas = [5    1.25    0.50
                6    0.90    0.30
                8    1.00    0.35];
Datos.fnom = 60;        
Res = NewtonRaphson(Datos);
%% Transient stability
% Faults:  Type Time  value
% Type(value):   1Load(Z), 2Fault(Node), 3open_line(NumLin)
Datos.Disturbios = [2  0.100  7   % Short circuit in 7 at 0.1s
                    3  0.183  6]; % Open line 5-7 at 0.183s
Datos.tmax = 2;
Y = Estabilidad_transitoria(Datos);
val = stepinfo(Y);

             


function T = Estabilidad_transitoria(Sistema,tmax);
% Analisis de estabilidad transitoria modelo clasico
% sin regulacion
% Entradas: las mismas del flujo de carga + 
%          .Disturbios [tiempo tipo valor]
%                      tiempo: ocurrencia del disturbio
%                      tipo:   1carga, 2fallo linea, 3apertura_linea
%                      un fallo es una carga de valor 0
%                      cada carga es una impedancia constante
%                      se abren todas las lineas conectadas al nodo
%          .tmax
%% calcular condiciones iniciales
Res =  NewtonRaphson(Sistema);
Ndis = length(Sistema.Disturbios(:,1));% Numero de disturbios
NumN = max([max(Sistema.Lineas(:,1)),max(Sistema.Lineas(:,2))]);
NG   = Sistema.Gen(:,1);
NumG = length(NG);
NC   = Sistema.Cargas(:,1);
NumC = length(NC);
YBUS = zeros(NumG,NumG,Ndis+1); % mas el caso base
%% Caso Base
[Ybusaum Vso] = Ybus_aumentada(Sistema,Res);
Vgo = abs(Vso);
Ango = angle(Vso);
NN = 1:NumN;
NR = (NumN+1):(NumN+NumG);
Ybusrm = Ybus_reducida(Ybusaum,NN,NR);
YBUS(:,:,1) = Ybusrm;
Pm = real(Res.Sn(1:NumG));
%% Disturbios
texto = sprintf('-------- Transitorio modelo clasico ----- \n');
for k = 1:Ndis
    if Sistema.Disturbios(k,1) == 2  % fallo
       nf = Sistema.Disturbios(k,3);  % nodo en fallo 
       ND = setdiff(1:NumN+NumG,nf);  % todos los nodos menos nf
       NDn = 1:NumN-1;
       NDr = NumN:(NumN+NumG-1);
       Ybusx = Ybusaum(ND,ND);
       Ybusrm=Ybus_reducida(Ybusx,NDn,NDr);
       YBUS(:,:,k+1) = Ybusrm; 
       texto = sprintf('%s >> Nodo(%d): Fallo \n',texto,nf);
    end
    if Sistema.Disturbios(k,1) == 3  % apertura linea
       Ybusx = Ybusaum;
       lin = Sistema.Disturbios(k,3);
       N1 = Sistema.Lineas(lin,1);
       N2 = Sistema.Lineas(lin,2);       
       texto = sprintf('%s >> Linea(%d-%d): Apertura \n',texto,N1,N2);
       YY = 1/(Sistema.Lineas(lin,3)+j*Sistema.Lineas(lin,4));
       bkm = Sistema.Lineas(lin,5);
       tap = Sistema.Lineas(lin,6);
       if (tap==0)
        tap = 1;
       end    
       tap = 1/tap;
       Ybusx(N1,N1) = Ybusx(N1,N1) - tap*tap*YY - j*bkm;
       Ybusx(N2,N2) = Ybusx(N2,N2) - YY         - j*bkm;
       Ybusx(N1,N2) = Ybusx(N1,N2) + tap*YY ;
       Ybusx(N2,N1) = Ybusx(N2,N1) + tap*YY ;              
       Ybusrm = Ybus_reducida(Ybusx,NN,NR);
       YBUS(:,:,k+1) = Ybusrm;
    end
end
texto = sprintf('%s -----------------------------------------',texto); 
%% Use the ode45 to solve the differential equation
M = 2*Sistema.Gen(:,8)/(2*pi*Sistema.fnom);
Xo = [Ango,zeros(NumG,1)];
tiempos = Sistema.Disturbios(:,2);
options = odeset('RelTol',1e-6,'AbsTol',ones(2*NumG,1)*1e-6);
[T X] = ode45(@(t,x) dinamica_sistema(t,x,M,YBUS,Vgo,Pm,tiempos,NumG),[0,Sistema.tmax],Xo,options);








function [Ybus Vn] = Ybus_aumentada(Sistema,Res);
NumN = max([max(Sistema.Lineas(:,1)),max(Sistema.Lineas(:,2))]);
NG   = Sistema.Gen(:,1);
NumG = length(NG);
NC   = Sistema.Cargas(:,1);
NumC = length(NC);
YbusB = CalcularYbus(Sistema.Lineas);
Ybus = zeros(NumN+NumG);
Ybus(1:NumN,1:NumN) = YbusB;
for k = 1:NumG
    n = NG(k);
    kk = k + NumN;
    xd = Sistema.Gen(k,5);
    yd = 1/(j*xd);
    Ybus(n,n) = Ybus(n,n) + yd;
    Ybus(kk,kk) = Ybus(kk,kk) + yd;
    Ybus(kk,n) = Ybus(kk,n) - yd;
    Ybus(n,kk) = Ybus(n,kk) - yd;
    % tension interna del generador
    I = conj(Res.Sn(n)/Res.Vn(n));
    Vn(k,1) = Res.Vn(n) + j*xd*I;
end
% convertir las cargas en impedancias e incluirlas en la Ybus
for k = 1:NumC
     n = NC(k);
     S = Res.Sn(n);
     V = abs(Res.Vn(n));
     Y = -conj(S/(V*V));
     Ybus(n,n) = Ybus(n,n) + Y;
end

function Ybusr = Ybus_reducida(Ybusaum,NN,NR);
% Eliminacion de nodos de kron
% NN los que se van
% NR los que se quedan
 Yg = Ybusaum(NR,NR);
 Yb = Ybusaum(NR,NN);
 Yc = Ybusaum(NN,NR);
 Ye = Ybusaum(NN,NN);
 Ybusr = Yg - Yb*inv(Ye)*Yc;
 
function dx = dinamica_sistema(t,x,M,YBUS,Vo,Pm,tiempos,NumG);  % dinamica del sistema sin control
% calcula la dinamica del sistema
% x = [delta, omega]
ps = 1;
for k = length(tiempos):-1:1
    if(t>tiempos(k))
       ps = k+1;
       break
    end
end
Ybusm = YBUS(:,:,ps);
Vg = Vo.*exp(j*x(1:NumG));
Ibus = Ybusm*Vg;
S = conj(Ibus).*Vg;
Pe = real(S);
dx = zeros(2*NumG,1);
dx(1:NumG) = x(NumG+1:2*NumG);
dx(NumG+1:2*NumG) = (Pm-Pe)./M;