function[fit,sol,Congestion_cost,Loss] = obj_fun(soln)
global test_data bus_system
for i = 1:size(soln,1)
    sol = soln(i,:);
    test_data1 = test_data;     
    busdata = test_data1.bus;
    bf = busdata(:,4);
    [n_bus,n_busdata] = size(busdata);
    branch_data = test_data1.branch;
    [n_branch,n_branchdata] = size(branch_data);
    
    
    %% Introduce Compensation
    n_pos = length(sol)/2; %% Number of FACTS positions
    comp_id = 4; %% The field where the compensation has to be done
    
    sol = check(test_data,sol,n_pos);
    for p = 1:n_pos %% Every FACTS position   
        branch = round(sol(p)); 
        comp_react = sol(p+2);
        branch_data(branch,comp_id) = branch_data(branch,comp_id)+comp_react;     
    end
    test_data1.branch = branch_data;  
    
    [V,Pi,Qi,Pg,Qg,Pl,Ql,Lpij,Lqij] = nrl_pf(bus_system,test_data1);
 
    
    p_cost = 1e3; %% Penalty cost
    penalty_mincon = 0;
    penalty_maxcon = 0;
    [r,c]  = find(V>=1.05);     %% Evaluating the deviation from maximum voltage stability constraint
    if isempty(c)~=1
        for n = 1:length(r)
            penalty_mincon = penalty_mincon + (abs(V(r(n))-1.05)*p_cost);
        end
    end

    [r,c]  = find(V<=0.97);  %% Evaluating the deviation from minimum voltage stability constraint
    if isempty(c)~=1
        for n = 1:length(r)
            penalty_maxcon = penalty_maxcon + (abs(V(r(n))-0.97)*p_cost);
        end
    end
    Congestion_cost = penalty_mincon+penalty_maxcon; %% Evaluating the final cost    
    Loss = sum(Lpij);
 
    fit(i) = Congestion_cost+Loss;
end
end

function[sol] = check(test_data,sol,n)
B = 1:length(test_data.branch);
a = round(sol(1:n));
A = unique(a);
if length(A) ~= length(a)    
   C = setdiff(B,A);
    m = 1; 
    for k = 1:length(a)
        n = find(a == a(k));
        if length(n) ~= 1
            for j = 2:length(n)
                a(n(j)) = C(m);
                m = m+1;
            end        
        end
    end
end
sol(1:n) = a;
end