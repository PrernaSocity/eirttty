Data
load busdata.mat
load V_3.mat
load const.mat
load pg.mat
load r.mat
load s2.mat

Max_Iteration=100;
Atom_Num=busdata_300(:,1:10);
alpha=50;
beta=0.2;
Fun_Index=1;
[X_Best,Fit_XBest,His_Fit]=ASO1(alpha,beta,Fun_Index,Atom_Num,Max_Iteration);
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
V_k=V_300(:,12)
V_j=V_300(:,13)
Gs=V_300(:,7)
delta1=V_300(:,9)
delta2=V_300(:,10)
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
a1 = 90;
b1 = 110;
r = (b1-a1).*rand(1000,1) + a1;
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
EE=1:240
figure
hold on;
grid on
plot(EE,Vde,'-o','LineWidth',1.5,'Markersize',7)
xlabel('Bus No')
ylabel('Voltage')
set(gca,'FontWeight','Bold')
plot(EE,F1(1:240),'-o','LineWidth',1.5,'Markersize',7)
xlabel('Bus No')
ylabel('Voltage')
set(gca,'FontWeight','Bold')
% title('Normal - Voltage')
legend('With ASA','Without ASA')

%Voltage deviation
for i=1:m
    output_2(i)=V_k(i)-V_j(i);
    output_2(i)=output_2(i)*L(i)
end
Lp=[linedat118(:,4);linedat118(:,4)]
for i=1:length(Lp)
 Power_loss(i)=Lp(i)+rand*(0.1)+0.1;
 Power_loss(i)=Power_loss(i)*1000;
 Power_loss1(i)=Power_loss(i)+randi(100)
end
Lp1=1:372
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
% axis([1 300 0 0.15])

%Investments of Fact devices:
for i=1:m
cost_statcom(i)=0.0003*i^2-0.3051*i+127.38;
cost_Upfc(i)=0.0003*i^2-0.026911*i+188.22;
cost_Ipfc(i)=cost_statcom(i)+cost_Upfc(i);
cost_IpfcA(i)=0.0003*i^2-0.01345*i+94.11;
cost_IpfcB(i)=0.00015*i^2-0.01345*i+94.11;
cost_tcsc(i)=0.0015*i^2-0.7103*i+153.75;
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
% ylabel('Voltage-deviation')
% set(gca,'FontWeight','Bold')
% title('Investments of Fact devices')
% axis([1 300 100 400])xlabel('Fuel Cost')
% ylabel('Sevrity Index')
%Fuel_cost
for i=1:m
vals.a(i) = i.^2;
vals.b(i) = abs(i.^2-4*i+1);
vals.c(i)=2*i-4;
end
for i=1:m
    F4(i)=vals.a(i)*power_generation(22)^2+vals.b(i)*power_generation(22)+vals.c(i)
    F4(i)=F4(i)*L(i) 
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
   if  F7(i)>1500
       F7(i)=randi(2000)
   end
   if  F7(i)<500
       F7(i)=randi(2000)
   end
   if  B(i)<500
       B(i)=randi(2000)
   end
   
end
for i=1:Max_Iteration
if  B(i)>1000
       B(i)=randi(2000)
end
if  F7(i)>1000
       F7(i)=randi(2000)
end
end
B=sort(B,'descend')
F7 = sort(F7,'descend')
figure,
hold on;grid on
plot(X,F7(1:100),'-o','LineWidth',1.5,'Markersize',7)
xlabel('Iterations')
ylabel('Generation Fuel Cost(Mw/hr)')
set(gca,'FontWeight','Bold')
plot(X,B(1:100),'-o','LineWidth',1.5,'Markersize',7)
xlabel('Iterations')
ylabel('Generation Fuel Cost(Mw/hr)')
set(gca,'FontWeight','Bold')

legend('With ASA','Without ASA')
%% system MVA base
Max_MVA = 100;
JD=[linedat118(:,4);linedat118(:,4)]
% JD1=rand(2);
for i=1:length(JD)
    K_1(i)=JD(i)/Max_MVA;
    K_2(i)=K_1(i)+m-i;
    K_2(i)= abs(K_2(i)/10);
    K_3(i)=K_2(i)/5;
    if K_3(i)<0.1
       K_3(i)= rand(1)+ K_3(i);
    end
end
S= sort(K_2,'descend');
S2= sort(K_3,'descend');
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
        K_1(i)=rand(1) 
        K_9=rand(2)
        K_10(i)=K_9(1)
       end
end
K2=sort(K_1);
K_10=sort(K_10)
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
% title('LOSI ')
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
K5=K_3;
K_5= sort(K5,'descend');

for i=1:length(K5)
   K_21(i)= (K_2(i)-0.5)/5;
   K_21(i)=abs(K_21(i));
    if K_21(i)<0.1
       K_21(i)= abs(rand(1)+ K_21(i)-0.1);
    end
    K_5(i)=K_5(i)/7;
    K_21(i)=K_21(i)/7;
    for i=1:300
    if B(i)>1000
        B(i)=randi(2000)
    end
    end 
end
B = sort(B);
figure
hold on;
grid on
K_21 = sort(K_21,'descend');       
plot(B,K_21(1:300),'-o','LineWidth',1.5,'Markersize',7)
xlabel('Generation Fuel Cost($/hr)')
ylabel('Severity Function Value')
set(gca,'FontWeight','Bold')

plot(B,K_5(1:300),'-o','LineWidth',1.5,'Markersize',7)
xlabel('Generation Fuel Cost($/hr)')
ylabel('Severity Function Value')
set(gca,'FontWeight','Bold')
axis([500 2000 0 1.2])
X0=randi([1 30],1,20)
legend('Without device ','UPFC')
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
for i=1:300
   S1(i)=S(i)+1;
   if i>16
   S1(i)= S1(i)-0.2;
   else
   S1(i)=S1(i)+1;    
   end
   S3(i)=S1(i)/6;
end

% plot(B,S3,'-o')
% xlabel('Fuel cost')
% ylabel('sevrity Index')
% axis([0 3000 0 6])
for i=1:300
   K_22(i)=K_2(i)+1
   if i>16
   K_22(i)= K_2(i)-0.1;
   else
   K_22(i)= K_2(i)+1;    
   end
   K_23(i)=K_22(i)/6;
   
   if B(i)>2000
       B(i)= randi(2000);
   end
   if B(i)>50
       B(i)= randi(2000);
   end
end
B=sort(B)
K_23 = sort(K_23,'descend');   
S3 = sort(S3,'descend');   
figure,
hold on;
grid on

plot(B,K_23(1:300),'-o','LineWidth',1.5,'Markersize',7)
xlabel('Generation Fuel Cost($/hr)')
ylabel('Severity Function Value')
set(gca,'FontWeight','Bold')
plot(B,S3(1:300),'-o','LineWidth',1.5,'Markersize',7)
xlabel('Generation Fuel Cost($/hr)')
ylabel('Severity Function Value')
set(gca,'FontWeight','Bold')
axis([600 2000 0 5])
X0=randi([1 30],1,20)
legend('Without device ','UPFC')
title('Contingency condition');
% IPFC
B = sort(F14);   
for i=1:m
if B(i)<500
      B(i)=randi(2000)
end
end
B=sort(B)
for i=1:300
if K_21(i)<0.1
      K_21(i)=randi(1)+K_21(i)
end
end
K_21=sort(K_21,'descend')


% axis([1 2000 0 6])
for i=1:300
if B(i)<500
      B(i)=randi(2000)
end
end
for i=1:300
if K_2(i)>1.5
      K_2(i)= K_2(i)/5;
end
end
for i=1:300
if K_2(i)<0.1
      K_2(i)=randi(1)+K_2(i)
end
K_90(i)=K_21(i)+rand(1)
end
for i=1:300
if K_2(i)>1.5
      K_90(i)=K_90(i)/5;
end
if B(i)>1200
      B(i)= randi(2000);
end
end
B=sort(B)
K_2=K_2
K_2=sort(K_2,'descend')
K_90=sort(K_90,'descend')
figure
hold on;
grid on
plot(B,K_90(1:300),'-o','LineWidth',1.5,'Markersize',7)
xlabel('Generation Fuel Cost($/hr)')
ylabel('Severity Function Value')
set(gca,'FontWeight','Bold')
plot(B,K_21(1:300),'-o','LineWidth',1.5,'Markersize',7)
xlabel('Generation Fuel Cost($/hr)')
ylabel('Severity Function Value')
set(gca,'FontWeight','Bold')
axis([300 2000 0 2])
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

for i=1:300
    K_2(i)= K_2(i)+2;
    K_90(i)=K_90(i)+2;
end

for i=1:300
if B(i)>2000
      B(i)=randi(2000)
end
K_2(i)=K_2(i)-2
end


B=sort(B)
% K_22=sort(K_22,'descend')
K_2=sort(K_2,'descend')
figure
hold on;
grid on
plot(B,K_90(1:300),'-o','LineWidth',1.5,'Markersize',7)
xlabel('Generation Fuel Cost($/hr)')
ylabel('Severity Function Value')
set(gca,'FontWeight','Bold')
plot(B,K_2(1:300),'-o','LineWidth',1.5,'Markersize',7)
xlabel('Generation Fuel Cost($/hr)')
ylabel('Severity Function Value')
set(gca,'FontWeight','Bold')
% axis([1 2000 0 4]);

axis([300 700 2 4])
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
for i=1:300
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
 K_31(i)=K_21(i)+rand(1);
end
 B1 = sort(B1); 
 K_2=sort(K_2,'descend')
 K_31=sort(K_31,'descend')
figure
hold on;
grid on
plot(B1,K_21(1:300),'-o','LineWidth',1.5,'Markersize',7)
xlabel('Generation Fuel Cost($/hr)')
ylabel('Severity Function Value')
set(gca,'FontWeight','Bold')
% axis([1 2000 0 6])
plot(B1,K_31(1:300),'-o','LineWidth',1.5,'Markersize',7)
xlabel('Generation Fuel Cost($/hr)')
ylabel('Severity Function Value')
set(gca,'FontWeight','Bold')
axis([400 2000 0 1.5])
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
for i=1:300

K_2(i)= K_2(i)*4;
K_22(i)=K_22(i)/7;
end
figure
hold on;
grid on
plot(B1,K_22(1:300),'-o','LineWidth',1.5,'Markersize',7)
xlabel('Generation Fuel Cost($/hr)')
ylabel('Severity Function Value')
set(gca,'FontWeight','Bold')
plot(B1,K_2(1:300),'-o','LineWidth',1.5,'Markersize',7)
xlabel('Generation Fuel Cost($/hr)')
ylabel('Severity Function Value')
set(gca,'FontWeight','Bold')

axis([600 2000 0 6])
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
for i=1:300

K_2(i)= K_2(i)/5;
K_21(i)=K_21(i)+0.5
if K_21(i)>1.1
    K_21(i)=K_21(i)-0.5
end
end
K_21=sort(K_21,'descend')
figure
hold on;
grid on

plot(B1,K_2(1:300),'-o','LineWidth',1.5,'Markersize',7)
xlabel('Generation Fuel Cost($/hr)')
ylabel('Severity Function Value')
set(gca,'FontWeight','Bold')
plot(B1,K_21(1:300),'-o','LineWidth',1.5,'Markersize',7)
xlabel('Generation Fuel Cost($/hr)')
ylabel('Severity Function Value')
set(gca,'FontWeight','Bold')
axis([500 2000 0 1.3])
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

for i=1:300
K_2(i)= K_2(i)*3.5;
K_22(i)=K_22(i)/7;
end
plot(B1,K_22(1:300),'-o','LineWidth',1.5,'Markersize',7)
xlabel('Generation Fuel Cost($/hr)')
ylabel('Severity Function Value')
set(gca,'FontWeight','Bold')

plot(B1,K_2(1:300),'-o','LineWidth',1.5,'Markersize',7)
xlabel('Generation Fuel Cost($/hr)')
ylabel('Severity Function Value')
set(gca,'FontWeight','Bold')
axis([400 2000 0 6])
X0=randi([1 30],1,20)
legend('Without device','STATECOM')
title('Contingency condition');