function [bestfit,bestfitness,bestsol,time]=FPA(Sol,objfun,lb,ub,N_iter)
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
              L=Levy(d);
              dS=L.*(Sol(i,:)-best);
              S(i,:)=Sol(i,:)+dS;

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

% Draw n Levy flight sample
function L=Levy(d)
% Levy exponent and coefficient
% For details, see Chapter 11 of the following book:
% Xin-She Yang, Nature-Inspired Optimization Algorithms, Elsevier, (2014).
beta=3/2;
sigma=(gamma(1+beta)*sin(pi*beta/2)/(gamma((1+beta)/2)*beta*2^((beta-1)/2)))^(1/beta);
    u=randn(1,d)*sigma;
    v=randn(1,d);
    step=u./abs(v).^(1/beta);
L=0.01*step; 
end
