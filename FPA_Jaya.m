function [bestfit,bestfitness,bestsol,time]=FPA_Jaya(Sol,objfun,lb,ub,N_iter)
Ub = ub(1,:);
Lb = lb(1,:);
[n,d] = size(Sol);

Fitness = feval(objfun,Sol);

% Find the current best
[fmin,I]=min(Fitness);
best=Sol(I,:);
S=Sol; 
p = 0.8;

% Start the iterations -- Flower Algorithm 
tic;
for t=1:N_iter,
    % Loop over all bats/solutions
    for i=1:n,
      % Pollens are carried by insects and thus can move in
      % large scale, large distance.
      % This L should replace by Levy flights  
      % Formula: x_i^{t+1}=x_i^t+ L (x_i^t-gbest)
          if rand>p,
              %% L=rand;              
              S(i,:) = updatepopulation(Sol,Fitness,i);
              
              % Check if the simple limits/bounds are OK
              S(i,:)=simplebounds(S(i,:),Lb,Ub);

              % If not, then local pollenation of neighbor flowers 
          else
              epsilon=rand;
              % Find random flowers in the neighbourhood
              JK=randperm(n);
              % As they are random, the first two entries also random
              % If the flower are the same or similar species, then
              % they can be pollenated, otherwise, no action.
              % Formula: x_i^{t+1}+epsilon*(x_j^t-x_k^t)
              S(i,:)=S(i,:)+epsilon*(Sol(JK(1),:)-Sol(JK(2),:));
              % Check if the simple limits/bounds are OK
              S(i,:)=simplebounds(S(i,:),Lb,Ub);
          end
          
          % Evaluate new solutions
           Fnew=feval(objfun,S(i,:));
          % If fitness improves (better solutions found), update then
            if (Fnew<=Fitness(i)),
                Sol(i,:)=S(i,:);
                Fitness(i)=Fnew;
           end
           
          % Update the current global best
          if Fnew<=fmin,
                best=S(i,:)   ;
                fmin=Fnew   ;
          end
    end
    bestsol(t,:) = best;
    bestfitness(t) = fmin;         
end
time = toc;
bestfit = bestfitness(end);
end

function [x_new]=updatepopulation(x,f,v)
[row,col]=size(x);
[t,tindex]=min(f);
Best=x(tindex,:);
[w,windex]=max(f);
worst=x(windex,:);
xnew=zeros(row,col);
for i = v
    for j=1:col
        r=rand(1,2);
        xnew(i,j)=x(i,j)+r(1)*(Best(j)-abs(x(i,j)))-r(2)*(worst(j)-abs(x(i,j)));
    end
end
x_new = xnew(v,:);
end

% Application of simple constraints
function s=simplebounds(s,Lb,Ub)
  % Apply the lower bound
  ns_tmp=s;
  I=ns_tmp<Lb;
  ns_tmp(I)=Lb(I);
  
  % Apply the upper bounds 
  J=ns_tmp>Ub;
  ns_tmp(J)=Ub(J);
  % Update this new move 
  s=ns_tmp;
end