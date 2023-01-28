function[fit,Congestion_cost,invest_cost,trans_stab] = model(soln)
global test_data trns
for i = 1:size(soln,1)
    sol = soln(i,:);
    test_data1 = test_data;     
    busdata = test_data1.bus;
    bf = busdata(:,4);
    [n_bus,n_busdata] = size(busdata);
    branch_data = test_data1.branch;
    [n_branch,n_branchdata] = size(branch_data);
    
    %% Find Slack Bus
    [slack_bus,bus_type] = find(test_data1.bus(:,2)==3);  %% Slack bus ID is 3
    vol_limits = busdata(:,12:13);  %% Getting voltage stability margins
    
    %% Introduce Compensation
    n_pos = length(sol)/2; %% Number of FACTS positions
    comp_id = 4; %% The field where the compensation has to be done
       
    for p = 1:n_pos %% Every FACTS position   
        branch = round(sol(p)); 
        comp_react = sol(p+2);
        branch_data(branch,comp_id) = branch_data(branch,comp_id)+comp_react;     
    end
    test_data1.branch = branch_data;    
    
    [results,success] = runpf1(test_data1);
     v_index = 8;    %% Index of the voltage in the output data
    
    branchdata = results.branch;
    busdata = results.bus;  
    
    V = busdata(:,v_index);
    p_cost = 1e3; %% Penalty cost
    penalty_mincon = 0;
    penalty_maxcon = 0;
    [r,c]  = find(V<vol_limits(:,2));     %% Evaluating the deviation from minimum voltage stability constraint
    if isempty(r)~=1
        for n = 1:length(r)
            penalty_mincon = penalty_mincon + (abs(V(r(n))-vol_limits(n,2))*p_cost);
        end
    end

    [r,c]  = find(V>vol_limits(:,1));  %% Evaluating the deviation from maximum voltage stability constraint
    if isempty(r)~=1
        for n = 1:length(r)
            penalty_maxcon = penalty_maxcon + (abs(V(r(n))-vol_limits(n,1))*p_cost);
        end
    end
    Congestion_cost(i) = penalty_mincon+penalty_maxcon; %% Evaluating the final cost
    
    
    %% Investment cost
    for p = 1:n_pos
        s = sol(p+2);
        cost(p) = 0.0003*s^2-0.2691*s+188.22;
    end
    invest_cost(i) = sum(cost);
    
    val = feval(trns);   % Tra
    
    a1 = val.RiseTime;
    a2 = val.SettlingTime;
    a3 = val.SettlingMin;
    a4 = val.SettlingMax;
    a5 = val.Overshoot;
    a6 = val.Undershoot;
    a7 = val.Peak;
    a8 = val.PeakTime;
    trans_stab(i) = a1+a2+a3+a4+a5+a6+a7+a8;
    
    fit(i) = Congestion_cost+invest_cost+trans_stab;
end