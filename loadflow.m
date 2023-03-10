% 

function [Pi Qi Pg Qg Pl Ql Lpij  Qij V ] = loadflow(nb,V,del,BMva,busd,Y)

lined = linedatas(nb);          % Get linedats..
% busd = busdatas(nb);            % Get busdatas..
Vm = pol2rect(V,del);           % Converting polar to rectangular..
Del = 180/pi*del;               % Bus Voltage Angles in Degree...
fb = lined(:,1);                % From bus number...
tb = lined(:,2);                % To bus number...
nl = length(fb);                % No. of Branches..
Pl = busd(:,7);                 % PLi..
Ql = busd(:,8);                 % QLi..

Iij = zeros(nb,nb);
Sij = zeros(nb,nb);
Si = zeros(nb,1);
Smax = (lined(:,7))';
% Bus Current Injections..
 I = Y*Vm;
 Im = abs(I);
 Ia = angle(I);
 
%Line Current Flows..
for m = 1:nl
    p = fb(m); q = tb(m);
    Iij(p,q) = -(Vm(p) - Vm(q))*Y(p,q); % Y(m,n) = -y(m,n)..
    Iij(q,p) = -Iij(p,q);
end
Iij = sparse(Iij);
Iijm = abs(Iij);
Iija = angle(Iij);

% Line Power Flows..
for m = 1:nb
    for n = 1:nb
        if m ~= n
            Sij(m,n) = Vm(m)*conj(Iij(m,n))*BMva;
        end
        Sij(m,n) = sparse(Sij(m,n));
        Pij(m,n) = real(Sij(m,n));
        Qij(m,n) = imag(Sij(m,n));
    end
end
for loop1=1:nl
  Sindex(1,loop1)=abs(Sij(lined(loop1,1),lined(loop1,2)))/(BMva*lined(loop1,7));
end
Sindex
% size(Si)
% size(Smax)
% Sindex=(Si./Smax)

% Line Losses..
Lij = zeros(nl,1);
for m = 1:nl
    p = fb(m); q = tb(m);
    Lij(m) = Sij(p,q) + Sij(q,p);
end
Lpij = real(Lij);
Lqij = imag(Lij);

% Bus Power Injections..
for i = 1:nb
    for k = 1:nb
        Si(i) = Si(i) + conj(Vm(i))* Vm(k)*Y(i,k)*BMva;
    end
end
Pi = real(Si);
Qi = -imag(Si);
% Pg = Pi+Pl;
Qg = Qi+Ql;
Pg = busd(:,5);
 ulb = [1 6 9 11 13 22 25 27 28 ];
% V(ulb) = [];Del(ulb) = [];Pi(ulb)= [];Qi(ulb)= [];Pg(ulb) = [];Qg(ulb)=[];
% Pl(ulb)=[];Ql(ulb)=[];

disp('#########################################################################################');
disp('-----------------------------------------------------------------------------------------');
disp('-----------------------------------------------------------------------------------------');
disp('| Bus |    V   |  Angle  |     Injection      |     Generation     |          Load      |');
disp('| No  |   pu   |  Degree |    MW   |   MVar   |    MW   |  Mvar    |     MW     |  MVar | ');
for m = 1:nb-length(ulb)
    disp('-----------------------------------------------------------------------------------------');
    fprintf('%3g', m); fprintf('  %8.4f', V(m)); fprintf('   %8.4f', Del(m));
    fprintf('  %8.3f', Pi(m)); fprintf('   %8.3f', Qi(m)); 
    fprintf('  %8.3f', Pg(m)); fprintf('   %8.3f', Qg(m)); 
    fprintf('  %8.3f', Pl(m)); fprintf('   %8.3f', Ql(m)); fprintf('\n');
end
disp('-----------------------------------------------------------------------------------------');
fprintf(' Total                  ');fprintf('  %8.3f', sum(Pi)); fprintf('   %8.3f', sum(Qi)); 
fprintf('  %8.3f', sum(Pi+Pl)); fprintf('   %8.3f', sum(Qi+Ql));
fprintf('  %8.3f', sum(Pl)); fprintf('   %8.3f', sum(Ql)); fprintf('\n');
disp('-----------------------------------------------------------------------------------------');
disp('#########################################################################################');

disp('-------------------------------------------------------------------------------------');
disp('                              Line FLow and Losses ');
disp('-------------------------------------------------------------------------------------');
disp('|From|To |    P    |    Q     | From| To |    P     |   Q     |      Line Loss      |');
disp('|Bus |Bus|   MW    |   MVar   | Bus | Bus|    MW    |  MVar   |     MW   |    MVar  |');
for m = 1:nl
    p = fb(m); q = tb(m);
    disp('-------------------------------------------------------------------------------------');
    fprintf('%4g', p); fprintf('%4g', q); fprintf('  %8.3f', Pij(p,q)); fprintf('   %8.3f', Qij(p,q)); 
    fprintf('   %4g', q); fprintf('%4g', p); fprintf('   %8.3f', Pij(q,p)); fprintf('   %8.3f', Qij(q,p));
    fprintf('  %8.3f', Lpij(m)); fprintf('   %8.3f', Lqij(m));
    fprintf('\n');
end
disp('-------------------------------------------------------------------------------------');
fprintf('   Total Loss                                                 ');
fprintf('  %8.3f', sum(Lpij)); fprintf('   %8.3f', sum(Lqij));  fprintf('\n');
disp('-------------------------------------------------------------------------------------');
disp('#####################################################################################');
loss = sum(Lpij);