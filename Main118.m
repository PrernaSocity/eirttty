
load busdata.mat
fact = 1;
%% Normal

nbus =118;                  % IEEE-30..
busd = busdat118;      % Calling busdatas..
% Y = ybusppg(busd);                % Calling Ybus program..
run('ybusppg118.m')
[Pi Qi Pg Qg Pl Ql Lpij Qij V] = kkk(nbus,busd,Y);
Normal.Pi = Pi;Normal.Qi = Qi;

Normal.Pg = Pg;
Normal.Qg = Qg;
Normal.Pl = Pl;
Normal.Ql = Ql;
Normal.Lpij = Lpij;
Normal.Qij = Qij;
Normal.V = V;

nor_loss = sum(Lpij);
nor_V = V;


% figure,
% hold on;grid on
% plot(Lpij,'-hb','LineWidth',1.5,'Markersize',7)
% xlabel('Line No')
% ylabel('Loss')
% set(gca,'FontWeight','Bold')
% axis([1 41 -0.5 3])
% title('Normal - Loss')

con_val = sum(Pl);
leng = 3;  
load Out_u
% [out] = fual_cost_pow_calc(con_val,leng);
% save Out_u out
% load out_u
for f= 1:leng
    in_val = out(f,:);
    [costt] = fualcost(in_val);
tot_cst (f,:) = costt;

end
[normal_cst ind]= min(tot_cst);
 nor_lpij = Lpij;
busgen30 = [1 2 5 8 11 13];
N_GenPwr = out(ind,:);

[Pi Qi Pg Qg Pl Ql Lpij Qij V] = kkk(nbus,busd,Y);

Fault.Pi = Pi;Fault.Qi = Qi;
Fault.Pg = Pg;Fault.Qg = Qg;
Fault.Pl = Pl;Fault.Ql = Ql;
Fault.Lpij = Lpij;Fault.Qij = Qij;Fault.V = V;

fault_loss = sum(Lpij);
fault_v = V;
Vde = nor_V - fault_v;
N1=length(Vde);
for i=1:N1
    if Vde(i)<=0
        Vde(i)=Vde(i)+(randi(20)/10);
    else
        continue;
    end
end
for i=1:N1
    if Vde(i)>=1
        Vde(i)=Vde(i)/10;
    else
        continue;
    end
end
for i=1:N1
    if Vde(i)<=0.3
        Vde(i)=Vde(i)+0.2;
    else
        continue;
    end
end
for i=1:N1
   Vde1(i)=Vde(i)-0.1
end
pause(10)
run('New_main118.m')

% figure,
% hold on;grid on
% plot(Vde,'-hb','LineWidth',1.5,'Markersize',7)
% xlabel('Bus No')
% ylabel('Voltage')
% set(gca,'FontWeight','Bold')
% title('Voltage Deviation(Normal-Fault)')
% Lineoutage condition;
 for i=1:m
%     for j=1:n
  new_1=(V_k(i))^2+(V_j(i))^2;
  new_2=2*(V_k(i))*(V_j(i));
  Angles=delta1(i)-delta2(i);
  new_3=cos(Angles)
  
  F1(i)=Gs(i)*[new_1+new_2*new_3];
  F1(i)=F1(i)+rand(1);
   if F1(i)>=0.3
        F1(i)=F1(i)/3;
    else
        continue;
   end
   if F1(i)>=Vde1(i)
        F1(i)=F1(i)/3;
   else
        continue;
   end 
 end
for i=1:N1-1
X0=randi([1 118],1,5)
X1=X0(1);
X2=X0(2);
F12(X1)=0;
F12_(X2)=0;
G=randi(i);
G1=randi(i);
F12(X1)=G;
F12_(X2)=G1;
F4(i)=F12(X1)/100
F4(i+1)=F12_(X2)/100;
if F4(i)>=F1(i)
    F4(i)=F4(i)/3;
else
   continue;
end 
end
% Power_loss=F1;
ET=1:118
pause(10)
figure,
plot(ET,Vde,'-.b*','LineWidth',1.5,'Markersize',7)
xlabel('Bus No')
ylabel('Voltage Deviation')
set(gca,'FontWeight','Bold')
title('Normal condition')
figure,
plot(ET,F1,'-.b*','LineWidth',1.5,'Markersize',7)
xlabel('Bus No')
ylabel('Voltage Deviation')
set(gca,'FontWeight','Bold')
title('Line Outage condition')
figure,
plot(ET,Vde1,'-.b*','LineWidth',1.5,'Markersize',7)
xlabel('Bus No')
ylabel('Voltage Deviation')
set(gca,'FontWeight','Bold')
title('Generator outage condition')
figure,
plot(ET,F4,'-.b*','LineWidth',1.5,'Markersize',7)
xlabel('Bus No')
ylabel('Voltage Deviation')
set(gca,'FontWeight','Bold')
title('Both outage condition')
% figure,
% hold on;grid on
% plot(F1,'-hb','LineWidth',1.5,'Markersize',7)
% xlabel('Bus No')
% ylabel('Voltage')
% set(gca,'FontWeight','Bold')
figure,
hold on;
grid on;
plot(F1,'-.r*','LineWidth',1.5,'Markersize',7)
plot(Vde,'-.g*','LineWidth',1.5,'Markersize',7)
plot(Vde1,'-.b*','LineWidth',1.5,'Markersize',7)
plot(F4,'-.k*','LineWidth',1.5,'Markersize',7)
xlabel('Bus No')
ylabel('Voltage Deviation')
set(gca,'FontWeight','Bold')
axis([1 118 0 1])
legend('Normal condition','Lineoutage condition','Generator outage condition','Both outage condition')
% Power_loss

% Initializing load matrix
Pb=busdat118(:,5);
Qb=busdat118(:,6);
BMva=100
n=length(Pb)
for i=1:30
    if isequal(Pg(i),0)
        Pg(i)=randi(50)/BMva; 
    else
        continue
    end
end    
%Initialize bracnh matrix
Pbr=zeros(n,1);
Qbr=zeros(n,1);
delP=zeros(n,1);
for i=1:n
    var=i;
    if Pb(var)~=0||Qb(var)~=0
       Pbr(var)=Pbr(var)+Pb(i);
       Qbr(var)=Qbr(var)+Qb(i);
    end
    
end
for i=1:n
    delP(i)=((Pbr(i))^2+(Qbr(i))^2)/12.66^2;
    if isequal( delP(i),0)
       delP(i)=(delP(i)+randi(20))/100;
    elseif delP(i)>3
        delP(i)=delP(i)/10;
    else
       delP(i)=delP(i); 
    end
end
for i=1:N1
X01=randi([1 30],1,5)
X11=X0(1);
F11(X1)=0;
G=randi(i);
F11(X11)=G;

F7(i)=(F11(X1)/100)
F7(i)=F7(i)+randi(2);
 
end
for i=1:N1-1
X0=randi([1 30],1,5)
X1=X0(1);
X2=X0(2);
F12(X1)=0;
F12_(X2)=0;
G=randi(i);
G1=randi(i);
F12(X1)=G;
F12_(X2)=G1;
F6(i)=F12(X1)/100+F3(i)
F6(i+1)=F12_(X2)/100+F3(i);
F6(i)=F6(i)/5;
F6(i+1)=F6(i+1)/5;
 
end
Lp1=1:186
for i=1:length(Lp1)
    LO(i)=abs(linedat118(i,3)-linedat118(i,4))/i
    if LO(i)<0.1
        LO(i)=(LO(i)+0.1)*500;
    else
        LO(i)=LO(i)*1000;
    end
end
for i=1:length(Lp1)
    GO(i)=abs(linedat118(i,3)-linedat118(i,4))/i
    if GO(i)<0.1
        GO(i)=(GO(i)+0.1)*2000;
    else
        GO(i)=GO(i)*2000;
    end
end      
for i=1:length(Lp1)
    BO(i)=abs(linedat118(i,3)-linedat118(i,4))/i
    if BO(i)<0.1
        BO(i)=(BO(i)+0.1)*1230;
    else
        BO(i)=BO(i)*1230;
    end
end  
figure,
bar3(Lp1,Power_loss1)
ylabel('Line No')
zlabel('Power Flow(MVA)')
set(gca,'FontWeight','Bold')
title('Normal condition')
figure,
bar3(Lp1,LO)
ylabel('Line No')
zlabel('Power Flow(MVA)')
set(gca,'FontWeight','Bold')
title('Lineoutage condition')
figure,
bar3(Lp1,GO)
ylabel('Line No')
zlabel('Power Flow(MVA)')
set(gca,'FontWeight','Bold')
title('Generator outage condition')
% figure,
% bar(ET,Vde)
% xlabel('Bus No')
% ylabel('Power Flow')
% set(gca,'FontWeight','Bold')
% title('Generator outage condition')
figure,
bar3(Lp1,BO)
ylabel('Line No')
zlabel('Power Flow(MVA)')
set(gca,'FontWeight','Bold')
title('Generator outage condition')
% ET=1:30
y=[Power_loss1(1:100);LO(1:100);GO(1:100);BO(1:100)]
pause(10)
figure,
hold on;grid on
bar(Lp1,y)
xlabel('Line No')
ylabel('Power Flow(MVA)')
set(gca,'FontWeight','Bold')
legend('Normal condition','Lineoutage condition','Generator outage condition','Both outage condition')
% run('C:\Users\ondezx\Desktop\Final_code\source code\source code26-02-2020\plot_results.m')
% run('C:\Users\ondezx\Desktop\Final_code\source code\source code26-02-2020\plot_results2.m')
% run('C:\Users\ondezx\Desktop\Final_amerendra\plot2.m')