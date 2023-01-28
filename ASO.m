function [X_Best,Fit_XBest,Functon_Best]=ASO(alpha,beta,Fun_Index,Atom_Num,Max_Iteration)
% Dim: Dimension of search space.
% Atom_Pop: Population (position) of atoms.
% Atom_V:  Velocity of atoms.
% Acc: Acceleration of atoms.
% M: Mass of atoms. 
% Atom_Num: Number of atom population.
% Fitness: Fitness of atoms.
% Max_Iteration: Maximum of iterations.
% X_Best: Best solution (position) found so far. 
% Fit_XBest: Best result corresponding to X_Best. 
% Functon_Best: The fitness over iterations. 
% Low: The low bound of search space.
% Up: The up bound of search space.
% alpha: Depth weight.
% beta: Multiplier weight
  [m,n]=size(Atom_Num);
  Iteration=1;
  [Low,Up,Dim]=Test_Functions_Range(Fun_Index); 
  % Randomly initialize positions and velocities of atoms.
     if size(Up,2)==1
        for i=1:m
             for j=1:n
               Atom_Pop(i,:)=abs(Atom_Num(i,j)+1).*((Up-Low)+Low);
               Atom_V(i,:)=abs(Atom_Num(i,j)+1).*((Up-Low)+Low);
             end
         end
     end
   
     if size(Up,2)>1
          for i=1:m
             for j=1:n
               Atom_Pop(:,j)=abs(Atom_Num(i,j)+1).*((Up-Low)+Low);
               Atom_V(:,j)=abs(Atom_Num(i,j)+1).*((Up-Low)+Low);
             end
         end
     end
 % Compute function fitness of atoms.
     for i=1:Atom_Num
       Fitness(i)=Test_Functions(Atom_Pop(i,:),Fun_Index,Dim);
     end
       Functon_Best=zeros(Max_Iteration,1);
       [Max_Fitness,Index]=min(Fitness);
       Functon_Best(1)=Fitness(Index);
       X_Best=Atom_Pop(Index,:);
     
 % Calculate acceleration.
 Atom_Acc=Acceleration(Atom_Pop,Fitness,Iteration,Max_Iteration,Dim,Atom_Num,X_Best,alpha,beta);
 % Iteration
  for Iteration=2:Max_Iteration 
           Functon_Best(Iteration)=Functon_Best(Iteration-1);
           for i=1:length(Atom_Num)
           Atom_V(i,:)=(Atom_Num(i)*Dim).*Atom_V(i);
           Atom_Pop=Atom_Pop+Atom_V/10^7;
           end
    
    
         for i=1:length(Atom_Num)
       % Relocate atom out of range.  
           TU= Atom_Pop(i,:)>Up;
           TL= Atom_Pop(i,:)<Low;
           R_=rand(Dim);
           Atom_Pop(i,:)=(Atom_Pop(i,:).*(~(TU+TL)))+((R_(i).*(Up-Low)+Low).*(TU+TL));
           %Evaluate atom. 
           Fitness(i)=Test_Functions(Atom_Pop(i,:),Fun_Index,Dim);
         end
        [Max_Fitness,Index]=min(Fitness);      
      for i=1:length(Atom_Num)
        if Max_Fitness<Functon_Best(Iteration)
             Functon_Best(Iteration)=Max_Fitness;
             X_Best=Atom_Pop(Index,:);
          else
            r=fix(rand*Atom_Num)+1;
             Atom_Pop(i,:)=X_Best;
        end
      end
      % Calculate acceleration.
       Atom_Acc=Acceleration(Atom_Pop,Fitness,Iteration,Max_Iteration,Dim,Atom_Num,X_Best,alpha,beta);
 end
Fit_XBest=Functon_Best(Iteration); 