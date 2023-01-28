%power_loss
V_k=Voltagedata(:,12)
V_j=Voltagedata(:,13)
Gs=Voltagedata(:,7)
delta1=Voltagedata(:,9)
delta2=Voltagedata(:,10)
m=length(V_k)
 for i=1:m
%     for j=1:n
  new_1=(V_k(i))^2+(V_j(i))^2;
  new_2=2*(V_k(i))*(V_j(i));
  Angles=delta1(i)-delta2(i);
  new_3=cos(Angles)
  F1(i)=Gs(i)*[new_1+new_2*new_3];
 end
 Power_loss=F1;
 %Voltage_deviation
;