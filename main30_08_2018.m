function[] = main30_08_2018()
clc;
clear all;
close all;
warning off
addpath('nrlfppg');
global test_data bus_system


%% Experiment
pos = [2 3 4 5];  % number of best positions
bus_sys = [30 118]; %% Bus systems used

an = 0;  % set 1 to redo the experiments
if an == 1
for ps = 1:length(pos) 
    for bs = 1:length(bus_sys)
        bus_system = bus_sys(bs);   % Bus system
        x_limits = [-0.17 0.17];
        test_data.bus = busdatas(bus_system);  % Bus data
        test_data.branch = linedatas(bus_system);  % Linedata
                
        busdata = test_data.bus;    %% Get Bus Data
        [n_bus,n_busdata] = size(busdata);  %% Get number of buses and the corresponding data count
        branchdata = test_data.branch;  %% Get the branch data
        [n_branch,n_branchdata] = size(branchdata);     %% Get the number of branches and the corresponding data
        
        [bus_id,bus_type] = find(test_data.bus(:,2)==2); 
        test_data.bus(bus_id,7) = test_data.bus(bus_id,7)+(test_data.bus(bus_id,7).*1.5);  %% Add some load
        
        [V,Pi,Qi,Pg,Qg,Pl,Ql,Lpij,Lqij] = nrl_pf(bus_system,test_data);
        
        
        %% FACTS connection
        n_bestpos = pos(ps);  %% Number of best positions where the FACTS can be connected
        
        
        %% Chromosome generation
        Npop = 10;  %% Population size

        init_pos = randi(n_branch,[Npop,n_bestpos]); %% Generate random positions where which the FACTS have to be connected
        init_comp = x_limits(1) + (x_limits(2)-x_limits(1)*rand(Npop,n_bestpos)); %% Arbitrary compensation level
        for i = 1:size(init_comp,2)
            branch_id = init_pos(:,i);   %% Collect the branch IDs 
            xline = branchdata(branch_id,4);  %% Xline from branch data
            init_comp(:,1) = xline.*init_comp(:,i);
        end
       
        %% Optimization
        initsol = [init_pos init_comp];  % Initial Solution
        xmin = repmat([ones(1,n_bestpos) x_limits(1).*ones(1,n_bestpos)],Npop,1);  % Minimum Bound
        xmax = repmat([n_branch.*ones(1,n_bestpos) x_limits(2).*ones(1,n_bestpos)],Npop,1);  % Maximum Bound
        fname = 'obj_fun';  % Filename 
        itermax = 100;  % Maximum Iteration
        
        disp('GWO')
        [bestfit,fitness,bestsol,time] = GWO(initsol,fname,xmin,xmax,itermax);  % GWO
        Gwo(ps,bs).bf = bestfit; Gwo(ps,bs).fit = fitness; Gwo(ps,bs).bs = bestsol; Gwo(ps,bs).ct = time; save Gwo Gwo
        
        disp('WOA')
        [bestfit,fitness,bestsol,time] = WOA(initsol,fname,xmin,xmax,itermax);  % WOA
        Woa(ps,bs).bf = bestfit; Woa(ps,bs).fit = fitness; Woa(ps,bs).bs = bestsol; Woa(ps,bs).ct = time; save Woa Woa
        
        disp('DA')
        [bestfit,fitness,bestsol,time] = DA(initsol,fname,xmin,xmax,itermax);  % DA
        Da(ps,bs).bf = bestfit; Da(ps,bs).fit = fitness; Da(ps,bs).bs = bestsol; Da(ps,bs).ct = time; save Da Da
         
        disp('FPA')
        [bestfit,fitness,bestsol,time] = FPA(initsol,fname,xmin,xmax,itermax);  % FPA
        Fpa(ps,bs).bf = bestfit; Fpa(ps,bs).fit = fitness; Fpa(ps,bs).bs = bestsol; Fpa(ps,bs).ct = time; save Fpa Fpa
         
        disp('Jaya')
        [bestfit,fitness,bestsol,time] = Jaya(initsol,fname,xmin,xmax,itermax);  % Jaya
        Jy(ps,bs).bf = bestfit; Jy(ps,bs).fit = fitness; Jy(ps,bs).bs = bestsol; Jy(ps,bs).ct = time; save Jy Jy
        
        disp('Proposed')
        [bestfit,fitness,bestsol,time] = FPA_Jaya(initsol,fname,xmin,xmax,itermax);  % Proposed
        Prop(ps,bs).bf = bestfit; Prop(ps,bs).fit = fitness; Prop(ps,bs).bs = bestsol; Prop(ps,bs).ct = time; save Prop Prop         
    end
end
end
plot_results()
end