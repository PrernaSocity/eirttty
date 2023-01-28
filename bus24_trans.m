function[val] = bus24_trans()
addpath('Transient Stability')
Datos.Lineas = [1	2	108	22	0	0	1	1	0	138	1	1.05	0.95;
	2	2	97	20	0	0	1	1	0	138	1	1.05	0.95;
	3	1	180	37	0	0	1	1	0	138	1	1.05	0.95;
	4	1	74	15	0	0	1	1	0	138	1	1.05	0.95;
	5	1	71	14	0	0	1	1	0	138	1	1.05	0.95;
	6	1	136	28	0	-100	2	1	0	138	1	1.05	0.95;
	7	2	125	25	0	0	2	1	0	138	1	1.05	0.95;
	8	1	171	35	0	0	2	1	0	138	1	1.05	0.95;
	9	1	175	36	0	0	1	1	0	138	1	1.05	0.95;
	10	1	195	40	0	0	2	1	0	138	1	1.05	0.95;
	11	1	0	0	0	0	3	1	0	230	1	1.05	0.95;
	12	1	0	0	0	0	3	1	0	230	1	1.05	0.95;
	13	3	265	54	0	0	3	1	0	230	1	1.05	0.95;
	14	2	194	39	0	0	3	1	0	230	1	1.05	0.95;
	15	2	317	64	0	0	4	1	0	230	1	1.05	0.95;
	16	2	100	20	0	0	4	1	0	230	1	1.05	0.95;
	17	1	0	0	0	0	4	1	0	230	1	1.05	0.95;
	18	2	333	68	0	0	4	1	0	230	1	1.05	0.95;
	19	1	181	37	0	0	3	1	0	230	1	1.05	0.95;
	20	1	128	26	0	0	3	1	0	230	1	1.05	0.95;
	21	2	0	0	0	0	4	1	0	230	1	1.05	0.95;
	22	2	0	0	0	0	4	1	0	230	1	1.05	0.95;
	23	2	0	0	0	0	3	1	0	230	1	1.05	0.95;
	24	1	0	0	0	0	4	1	0	230	1	1.05	0.95;
    ];

Datos.Gen = [1	76  1.035 0 0.02 0 0 500.0
             2	76  1.035 0 0.295 0 0 30.3 
             7	80  1.025 0 0.2495 0 0 35.8              
             14	0 0.98 0 0.262  0 0 28.6
             15	12 1.014 0 0.67 0 0 26.0 
             16	155 1.017 0 0.254 0 0 34.8
             18	400 1.05 0 0.295 0 0 26.4 
             21	400 1.05 0 0.290 0 0 24.3
             22	50  1.05 0 0.2106 0 0 34.5 
             23	155 1.05 0 0.1 0 0 42.0];
Datos.Cargas = [3	180	37	
                4	74	15	
                5	71	14	
                6	136	28
                8	171	35	
                9	175	36	
                10	195	40
                11	0	0	
                12	0	0
                17	0	0
                19	181	37	
	            20	128	26
                24	0	0];
Datos.fnom = 60;        

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