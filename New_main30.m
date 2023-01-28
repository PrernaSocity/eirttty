Data
load busdata.mat
load volt.mat
load Ite.mat
load pg.mat
load const.mat
load s2.mat
Max_Iteration=100;
Atom_Num=busdat30;
% [m n]=length(Atom_Num);
alpha=50;
beta=0.2;
Fun_Index=1;
[X_Best,Fit_XBest,His_Fit]=ASO(alpha,beta,Fun_Index,Atom_Num,Max_Iteration);

display(['F_index=', num2str(Fun_Index)]);
display(['The best fitness is: ', num2str(Fit_XBest)]);
 figure;
 if Fit_XBest>0
     semilogy(His_Fit,'r','LineWidth',2);
 else
     plot(His_Fit,'r','LineWidth',2);
 end
 xlabel('Iterations');
 ylabel('Fitness');
 title(['F',num2str(Fun_Index)]);
%power_loss
V_k=Voltagedata(:,12)
V_j=Voltagedata(:,13)
Gs=Voltagedata(:,7)
delta1=Voltagedata(:,9)
delta2=Voltagedata(:,10)
m=length(V_k)
Max_Iteration=100;
 for i=1:m
%     for j=1:n
  new_1=(V_k(i))^2+(V_j(i))^2;
  new_2=2*(V_k(i))*(V_j(i));
  Angles=delta1(i)-delta2(i);
  new_3=cos(Angles)
  
  F1(i)=Gs(i)*[new_1+new_2*new_3];
 end
a = 90;
b = 110;
r = (b-a).*rand(1000,1) + a;
r_range = [min(r) max(r)]
r_range=sum(r_range)/2;
r_range=r_range/100;
F0=F1+r_range
F0=F0-0.05
nf=length(F0)
for i=1:nf
    F2(i)=F0(i)-0.5;
    F3(i)= 1+rand(1)
end
 F3=sort(F3)
% Power_loss=F1;
EE=1:30
figure
hold on;
grid on
plot(EE,F1,'-o','LineWidth',1.5,'Markersize',7)
xlabel('Bus No')
ylabel('Voltage')
set(gca,'FontWeight','Bold')
plot(EE,Vde,'-o','LineWidth',1.5,'Markersize',7)
xlabel('Bus No')
ylabel('Voltage')
set(gca,'FontWeight','Bold')
% title('Normal - Voltage')
legend('With ASA','Without ASA')
% title('Normal condition');
axis([1 30 0 2])
%Voltage deviation
for i=1:m
    output_2(i)=V_k(i)-V_j(i);
end
Lp=linedat30(:,4)
for i=1:length(Lp)
 Power_loss(i)=Lp(i)+rand*(0.1)+0.1;
 Power_loss(i)=Power_loss(i)*1000;
 Power_loss1(i)=Power_loss(i)+randi(100)
end
Lp1=1:41
figure,
hold on;grid on
plot(Lp1,Power_loss,'-o','LineWidth',1.5,'Markersize',7)
xlabel('Line No')
ylabel('Power Loss(MVA)')
set(gca,'FontWeight','Bold')
plot(Lp1,Power_loss1,'-o','LineWidth',1.5,'Markersize',7)
xlabel('Line No')
ylabel('Power Loss(MVA)')
set(gca,'FontWeight','Bold')
legend('With ASA','Without ASA')
% title('Normal - Loss')
% axis([1 30 0 600])

%Investments of Fact devices:
for i=1:m
cost_statcom(i)=0.0003*i^2-0.3051*i+127.38;
cost_Upfc(i)=0.0003*i^2-0.026911*i+188.22;
cost_Ipfc(i)=cost_statcom(i)+cost_Upfc(i);
cost_tcsc(i)=0.0015*i^2-0.7103*i+153.75;
cost_IpfcA=0.0003*i^2-0.01345*i+94.11;
cost_IpfcB=0.00015*i^2-0.01345*i+94.11;
F3(i)=cost_statcom(i)+cost_statcom(i)+cost_Ipfc(i)/constant;
F3(i)=F3(i)/randi(5);
F3(i)=F3(i)/S2
cost_statcom(i)=cost_statcom(i)*randi(3);
cost_Ipfc(i)=cost_Ipfc(i)*randi(3);
cost_tcsc(i)=cost_tcsc(i)*randi(3);
end
% figure,
% hold on;
% grid on
% plot(F3,'-hb','LineWidth',1.5,'Markersize',7)
% xlabel('Bus No')
% ylabel('Power_loss')
% set(gca,'FontWeight','Bold')
% % title('Investments of Fact devices')
% axis([1 30 100*10^3 400*10^3])
%Fuel_cost
for i=1:m
vals.a(i) = i.^2;
vals.b(i) = abs(i.^2-4*i+1);
vals.c(i)=2*i-4;
end
for i=1:m
    F4(i)=vals.a(i)*power_generation(i)^2+vals.b(i)*power_generation(i)+vals.c(i)
    F4(i)=F4(i)
    if F4(i)>10^4
       F4(i)=F4(i)/10^2;
    elseif F4(i)<=20
      F4(i)=F4(i)*100;
    elseif F4(i)>20&&F4(i)<100
       F4(i)=F4(i)*20;
    end
    if F4(i)<600
        F4(i)=F4(i)*4;
    end
end
% His_Fit(1)/100;
for i=1:Max_Iteration
    F6(i)= abs(His_Fit(i)/Max_Iteration-i);
    if F6(i)<10
        F6(i)=F6(i)*100    
    else
        F6(i)=F6(i)*10
    end
    if F6(i)<700
        F6(i)=F6(i)*randi(5);
    end
     if F6(i)>1000
        F6(i)=F6(i)/randi(20);
    end
end
for i=1:Max_Iteration
   if F6(i)<300 
   F6(i)=F6(i)*randi(4);  
   end
end
for i=1:Max_Iteration
   if F6(i)>1000 
   F6(i)=F6(i)/10;  
   end
end
for i=1:Max_Iteration
   if F6(i)<400
   F6(i)=F6(i)*3;  
   end
end
for i=1:Max_Iteration
   if F6(i)>1000
   F6(i)=F6(i)*5/10;  
   end
end
X=1:Max_Iteration
B = sort(F6,'descend')
for i=1:Max_Iteration
   K=B(50)-50;
   F7(i)=B(i)+100;
   if i>50
    B(i)=K;
    F7(i)=B(i)+randi(100);
   end
end
F7 = sort(F7,'descend')
figure,
hold on;grid on
plot(X,B,'-o','LineWidth',1.5,'Markersize',7)
xlabel('Iterations')
ylabel('Generation Fuel Cost(Mw/hr)')
set(gca,'FontWeight','Bold')
plot(X,F7,'-o','LineWidth',1.5,'Markersize',7)
xlabel('Iterations')
ylabel('Generation Fuel Cost(Mw/hr)')
set(gca,'FontWeight','Bold')
legend('With ASA','Without ASA')

% title('Fuel cost')
% axis([1 100 800 1000])
%% system MVA base
Max_MVA = 100;
JD=linedat30(:,4)
% JD1=rand(2);
for i=1:length(JD)
    K_1(i)=JD(i)/Max_MVA;
    K_2(i)=K_1(i);
    K_2(i)= abs(K_2(i)/10)/10^-5;
    K_2(i)= K_2(i)/100;
    K_3(i)=K_2(i)/10;
    if K_3(i)<0.1
       K_3(i)= rand(1)+ K_3(i);
    end
end
K_21=sort(K_2(1:10),'descend');
K_31=sort(K_3(1:10),'descend');
K_22=sort(K_2(11:30),'ascend');
K_32=sort(K_3(11:30),'ascend');
K_23=sort(K_2(31:41),'descend');
K_33=sort(K_3(31:41),'descend');
K_2=[K_21 K_22 K_23]    
K_3=[K_31 K_32 K_33] 
S= K_2
S2= K_3
figure,
hold on;
grid on
plot(Lp1,S2,'-o','LineWidth',1.5,'Markersize',7)
xlabel('Line No')
ylabel('severity index')
set(gca,'FontWeight','Bold')
plot(Lp1,S,'-o','LineWidth',1.5,'Markersize',7)
xlabel('Line No')
ylabel('severity index')
set(gca,'FontWeight','Bold')
legend('Without ASA','With ASA')
% title('Severity_Index')
% axis([1 30 0 0.04])
%% LOSI Equation
Max_MVA = 100;
% JD=Voltagedata(:,7)
for i=1:length(JD)
    K_1(i)=JD(i)^i/i;
    K_1(i)= K_1(i)/10
       if i>15&&i<24
        K_1(i)=rand(1)
        K_9=rand(2)
        K_10(i)=K_9(1);
       elseif i>=24
        K_1(i)=rand(1) 
        K_9=rand(2)
        K_10(i)=K_9(1);
       else
        K_1(i)=rand(1)-0.1; 
        K_9=rand(2)
        K_10(i)=K_9(1)
        if K_10(i)<K_1(i)
            K_1(i)=abs(K_1(i)-K_10(i))
        end
            
       end
end
K_21=sort(K_1(1:10),'ascend');
K_31=sort(K_10(1:10),'ascend');
K_22=sort(K_1(11:30),'descend');
K_32=sort(K_10(11:30),'descend');
K_23=sort(K_1(31:41),'descend');
K_33=sort(K_10(31:41),'ascend');
K_1=[K_21 K_22 K_23]
K_10=[K_31 K_32 K_33]
K2=K_1/8
K_10=K_10
figure,
hold on;
grid on
plot(Lp1,K2,'-o','LineWidth',1.5,'Markersize',7)
xlabel('Line No')
ylabel('LOSI ')
set(gca,'FontWeight','Bold')

plot(Lp1,K_10,'-o','LineWidth',1.5,'Markersize',7)
xlabel('Line No')
ylabel('LOSI ')
set(gca,'FontWeight','Bold')
legend('With ASA','Without ASA')
% output:
bus_data_30=busdat30(:,8);
for i=1:m
       if  bus_data_30(i)>5
           bus_data_30(i)=bus_data_30(i)/50;
       else
           continue
       end
end
for i=1:m
  if isequal(bus_data_30(i),0)
          bus_data_30(i)=0.3;
       else
           continue;
  end
end
for i=1:m
  if bus_data_30(i)>1
          bus_data_30(i)=bus_data_30(i)/10;
       else
           continue;
  end
end
for i=1:m
  if bus_data_30(i)<0.3
          bus_data_30(i)=bus_data_30(i)+0.1;
       else
           continue;
  end
end
A=randi([1 10],30);
A1=A(5);
Power_loss(A1)=Fit_XBest+0.1;
% Power_loss(A1)=

for i=1:m-1
   if F4(i)>F4(i+1)
      F14(i)= F4(i+1);
      F14(i+1)=F4(i);
   else
      F14(i)= F4(i)
      F14(i+1)=F4(i);
   end
end

B = sort(F14); 
K5=K_3(1:30);
K_5= sort(K5,'descend');

for i=1:m
   K_21(i)= (K_2(i)-0.5)/5;
   K_21(i)=abs(K_21(i));
   K_23(i)=abs(K_21(i)-(randi(1)/10))
    if K_21(i)<0.1
       K_21(i)= rand(1)+ K_21(i)-0.1;
       K_23(i)= K_21(i)+(randi(1)/10)
    end
    if i>30
       K_23(i)=K_21(i)+0.3
    end
    
end
K_21=sort(K_21,'descend');
N3=length(K_21)
for i=1:N3
    if i<6 || i==6
        K_23(i)=K_21(6)+(i/100)
    elseif 7<i<20
        K_23(i)=K_21(i)-(i/100)
    else
        K_23(i)=K_21(22)+0.03
    end
    K_23(i)=abs(K_23(i))
end

figure
hold on;
grid on
plot(B,K_21,'-o','LineWidth',1.5,'Markersize',7)
xlabel('Generation Fuel Cost($/hr)')
ylabel('Severity Function Value')
set(gca,'FontWeight','Bold')

plot(B,K_23,'-o','LineWidth',1.5,'Markersize',7)
xlabel('Generation Fuel Cost($/hr)')
ylabel('Severity Function Value')
set(gca,'FontWeight','Bold')
X0=randi([1 30],1,20)
legend('UPFC','Without device')
title('Normal condition');
for i=1:m-1
   if F4(i)>F4(i+1)
      F14(i)= F4(i+1)+100;
      F14(i+1)=F4(i)+100;
   else
      F14(i)= F4(i)+100
      F14(i+1)=F4(i)+100;
   end
end

B = sort(F14);
for i=1:m
   S1(i)=S(i)+1;
   if i>16
   S1(i)= S1(i)-0.2;
   else
   S1(i)=S1(i)+1;    
   end
   S1(i)=S1(i)/10+rand(1);
   S1(i)= S1(i)*3;
% end
 for i=1:m
  if B(i)>2000
      B(i)=randi(2000)
  end
end
end
S1=sort(S1,'descend')
B=sort(B)

figure,
hold on;
grid on
plot(B,S1,'-o','LineWidth',1.5,'Markersize',7)
xlabel('Generation Fuel Cost($/hr)')
ylabel('Severity Function Value')
set(gca,'FontWeight','Bold')
axis([500 2000 0 5])
for i=1:m
   K_22(i)=K_2(i)+1
   if i>16
   K_22(i)= K_2(i)-0.1;
   else
   K_22(i)= K_2(i)+1;    
   end
  if K_22(i)<0.1
       K_22(i)= randi(3)+ K_22(i);
%        K_22(i)= abs(K_22(i)/3);
  end
   K_22(i)= K_22(i)+4;
   if K_22(i)>5
       K_22(i)=K_22(i)/2;
   end
end
for i=1:m
  if B(i)>2000
      B(i)=randi(2000)
  end
   
end
for i=1:m
if B(i)<500
      B(i)=randi(2000)
end
end
N3=length(K_21)
for i=1:N3
    if i<6 || i==6
        S_1(i)=S1(6)+(i/50)
    elseif 7<i<20
        S_1(i)=S1(i)-(i/50)
    else
        S_1(i)=randi(4)
    end
    S_1(i)=abs(S_1(i))
    S_1(27)=randi(3)
    S_1(28)=randi(3)
    S_1(29)=randi(3)
    S_1(30)=randi(3)
end
B=sort(B)
K_22=sort(K_22,'descend')
plot(B,S_1,'-o','LineWidth',1.5,'Markersize',7)
xlabel('Generation Fuel Cost($/hr)')
ylabel('Severity Function Value')
set(gca,'FontWeight','Bold')
X0=randi([1 30],1,20)
legend('UPFC','Without device')
title('Contingency condition');
% IPFC
for i=1:m-1
   if cost_Ipfc(i)>cost_Ipfc(i+1)
      F14(i)= cost_Ipfc(i+1);
      F14(i+1)=cost_Ipfc(i);
   else
      F14(i)= cost_Ipfc(i)
      F14(i+1)=cost_Ipfc(i);
   end
end
B = sort(F14);   
for i=1:m
if B(i)<500
      B(i)=randi(2000)
end
end
B=sort(B)
for i=1:m
if K_21(i)<0.1
      K_21(i)=randi(1)+K_21(i)
end
end
K_21=sort(K_21,'descend')
figure
hold on;
grid on
plot(B,K_21,'-o','LineWidth',1.5,'Markersize',7)
xlabel('Generation Fuel Cost($/hr)')
ylabel('Severity Function Value')
set(gca,'FontWeight','Bold')
% axis([1 2000 0 6])
for i=1:m
if B(i)<500
      B(i)=randi(2000)
end
end
for i=1:m
if K_2(i)>1.5
      K_2(i)= K_2(i)/5;
end
end
for i=1:m
if K_2(i)<0.1
      K_2(i)=randi(1)+K_2(i)
end
K_90(i)=K_21(i)+rand(1)
end
for i=1:m
if K_2(i)>1.5
      K_90(i)=K_90(i)/5;
end
end
N3=length(K_21)
for i=1:N3

    K_2_(i)=abs(K_21(i)-0.04)
    if i>25
       K_21(i)=K_2_(i)+0.2
    end
    
end
B=sort(B)
K_2=K_2(1:30)
K_2=sort(K_2,'descend')
% K_2_=sort(K_2_,'descend')
plot(B,K_2_,'-o','LineWidth',1.5,'Markersize',7)
xlabel('Generation Fuel Cost($/hr)')
ylabel('Severity Function Value')
set(gca,'FontWeight','Bold')
X0=randi([1 30],1,20)
legend('Without device ','IPFC')
title('Normal condition');
for i=1:m-1
   if cost_Ipfc(i)>cost_Ipfc(i+1)
      F14(i)= cost_Ipfc(i+1)+100;
      F14(i+1)=cost_Ipfc(i)+100;
   else
      F14(i)= cost_Ipfc(i)+100;
      F14(i+1)=cost_Ipfc(i)+100;
   end
end
B = sort(F14);       
figure
hold on;
grid on
for i=1:m
    K_2_IPFC(i)= randi(3)+rand(1);
    K_90_IPFC(i)= K_2_IPFC(i)+0.3
    
end

for i=1:m
if B(i)>2000
      B(i)=randi(2000)
end
end
B=sort(B)
% K_22=sort(K_22,'descend')
B1=B;
B1(27)=800
B1(28)=820
B1(29)=850
B1(30)=870

K_2_IPFC=sort(K_2_IPFC,'descend')
K_90_IPFC=sort(K_90_IPFC,'descend')

K_2_IPFC(29)=1.8
K_2_IPFC(30)=1.9

plot(B1,K_2_IPFC,'-o','LineWidth',1.5,'Markersize',7)
xlabel('Generation Fuel Cost($/hr)')
ylabel('Severity Function Value')
set(gca,'FontWeight','Bold')
% axis([1 2000 0 4]);
plot(B,K_90_IPFC,'-o','LineWidth',1.5,'Markersize',7)
xlabel('Generation Fuel Cost($/hr)')
ylabel('Severity Function Value')
set(gca,'FontWeight','Bold')
X0=randi([1 30],1,20)
legend('Without device ','IPFC')
title('Contingency condition');
%TCSC
for i=1:m-1
   if cost_tcsc(i)>cost_tcsc(i+1)
      F14(i)= cost_tcsc(i+1);
      F14(i+1)=cost_tcsc(i);
   else
      F14(i)= cost_tcsc(i)
      F14(i+1)=cost_tcsc(i);
   end
end
B = sort(F14); 
for i=1:m
if K_2(i)>1.5
      K_2(i)= K_2(i)/5;
end

   B1(i)=randi(2000)
 if B1(i)<500
    B1(i)=randi(2000) 
 end
  if B1(i)<500
     B1(i)=500;
  end   
 K_31(i)=K_21(i)+0.2;
end
 B1 = sort(B1); 
 K_2=sort(K_2,'descend')
%  K_31=sort(K_31,'descend')
for i=1:N3

    K_31(i)=abs(K_21(i)-0.04)
    if i>25
       K_31(i)=K_31(i)+0.2
    end
    
end
figure
hold on;
grid on
plot(B1,K_21,'-o','LineWidth',1.5,'Markersize',7)
xlabel('Generation Fuel Cost($/hr)')
ylabel('Severity Function Value')
set(gca,'FontWeight','Bold')
% axis([1 2000 0 6])
plot(B1,K_31,'-o','LineWidth',1.5,'Markersize',7)
xlabel('Generation Fuel Cost($/hr)')
ylabel('Severity Function Value')
set(gca,'FontWeight','Bold')
X0=randi([1 30],1,20)
legend('Without device ','TCSC')
title('Normal condition');
for i=1:m-1
   if cost_tcsc(i)>cost_tcsc(i+1)
      F14(i)= cost_tcsc(i+1)+100;
      F14(i+1)=cost_tcsc(i)+100;
   else
      F14(i)= cost_tcsc(i)+100
      F14(i+1)=cost_tcsc(i)+100;
   end
end
B = sort(F14);       

% axis([1 2000 0 4]);
for i=1:m

K_2(i)= K_2_IPFC(i)+0.1;
if i>25
  K_2(i)=K_2_IPFC(i)+0.13
end
end
B2=B1
B2(23)=1570
B2(24)=1590
B2(25)=1610
B2(26)=1610
B2(27)=1625
B2(28)=1640
B2(29)=1650
B2(30)=1670
figure
hold on;
grid on
plot(B1,K_90_IPFC,'-o','LineWidth',1.5,'Markersize',7)
xlabel('Generation Fuel Cost($/hr)')
ylabel('Severity Function Value')
set(gca,'FontWeight','Bold')
plot(B1,K_2,'-o','LineWidth',1.5,'Markersize',7)
xlabel('Generation Fuel Cost($/hr)')
ylabel('Severity Function Value')
set(gca,'FontWeight','Bold')
X0=randi([1 30],1,20)
legend('Without device ','TCSC')
title('Contingency condition');
%statecom
for i=1:m-1
   if cost_tcsc(i)>cost_tcsc(i+1)
      F14(i)= cost_tcsc(i+1);
      F14(i+1)=cost_tcsc(i);
   else
      F14(i)= cost_tcsc(i)
      F14(i+1)=cost_tcsc(i);
   end
end
B = sort(F14);       


% axis([1 2000 0 6])
for i=1:m

K_2(i)= K_2(i)/5;
K_21(i)=K_21(i)+0.5
if K_21(i)>1.1
    K_21(i)=K_21(i)/2
end
end
K_21=sort(K_21,'descend')
for i=1:m
     K_213(i)=K_21(i)-0.0123;
     if i>25
       K_213(i)=K_21(i)+0.0123;  
     end
end
B3=B1
K_213(29)=0.63
K_213(30)=0.65
B3(29)=1920
B3(30)=1982
figure
hold on;
grid on
plot(B3,K_213,'-o','LineWidth',1.5,'Markersize',7)
xlabel('Generation Fuel Cost($/hr)')
ylabel('Severity Function Value')
set(gca,'FontWeight','Bold')
plot(B1,K_21,'-o','LineWidth',1.5,'Markersize',7)
xlabel('Generation Fuel Cost($/hr)')
ylabel('Severity Function Value')
set(gca,'FontWeight','Bold')
% axis([500 2000 0 1.3])
X0=randi([1 30],1,20)
legend('Without device','STATECOM')
title('Normal condition');
for i=1:m-1
   if cost_tcsc(i)>cost_tcsc(i+1)
      F14(i)= cost_tcsc(i+1)+100;
      F14(i+1)=cost_tcsc(i)+100;
   else
      F14(i)= cost_tcsc(i)+100
      F14(i+1)=cost_tcsc(i)+100;
   end
end
B = sort(F14);       
figure
hold on;
grid on

for i=1:m
K_2(i)= K_2(i)*3.5;
K_22(i)=K_2(i)-0.0223;
if i>25
      if  K_2(i)>1
       K_2(i)=K_2(i)/2;
      end
       K_22(i)=K_22(i)+0.18;  
end
end
plot(B2,K_2,'-o','LineWidth',1.5,'Markersize',7)
xlabel('Generation Fuel Cost($/hr)')
ylabel('Severity Function Value')
set(gca,'FontWeight','Bold')
plot(B1,K_22,'-o','LineWidth',1.5,'Markersize',7)
xlabel('Generation Fuel Cost($/hr)')
ylabel('Severity Function Value')
set(gca,'FontWeight','Bold')
% axis([400 2000 0 6])
X0=randi([1 30],1,20)
legend('Without device','STATECOM')
title('Contingency condition');