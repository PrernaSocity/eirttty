function Acc=Acceleration(Atom_Pop,Fitness,Iteration,Max_Iteration,Dim,Atom_Num,X_Best,alpha,beta)
%Calculate mass 
  M=exp(-(Fitness-max(Fitness))./(max(Fitness)-min(Fitness)));
  M=M./sum(M);  
  
 
    G=exp(-20*Iteration/Max_Iteration); 
    Kbest=Atom_Num-(Atom_Num-2)*(Iteration/Max_Iteration)^0.5;
    Kbest=floor(Kbest)+1;
    [Des_M Index_M]=sort(M,'descend');
    
for i=1:length(Atom_Num)      
   E(i,:)=zeros(1,Dim);   
  MK=sum(Kbest/Atom_Pop(Index_M(1),:),1);
   Distance=norm(Atom_Pop(i,:)-MK(1,:));   
     for k=1:10
                  j=MK(k);       
                   %Calculate LJ-potential
                  Potential=abs(LJPotential(Atom_Pop(i),Atom_Pop(i),Iteration,Max_Iteration,Distance));                   
                  E(i,:)=E(i,:)+Potential.*((Atom_Pop(i)-Atom_Num(i,3))/(norm(Atom_Pop(i)-Atom_Num(i,3))+eps));      
                  E1(i,:)=E(i,:)*i*k;
     end
 
        E(i,:)=alpha*E(i,:)+beta*(X_Best-Atom_Pop(i,:));
        %Calculate acceleration
     a(i,:)=E(i,:)./M; 
end
try
    for i=1:m
    Final_fitness(i)=E(i)+a(i)+Fitness(i)+X_Best(i)+G(i)
    end
end

  
Acc=a.*G;