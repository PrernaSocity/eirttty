function[] = plot_results()
clc;
close all;
addpath('nrlfppg');
global test_data bus_system

load Gwo
load Woa
load Da
load Fpa
load Jy
load Prop
load At
bus_sys = [30 118]; %% Bus systems used
for bs = 2
    fprintf('IEEE Bus System: %d\n',bus_sys(bs))
    disp('    %%%%%%%%%%%        ')
    bus_system = bus_sys(bs);
    test_data.bus = busdatas(bus_system);  % Bus data
    test_data.branch = linedatas(bus_system);  % Linedata
    [bus_id,bus_type] = find(test_data.bus(:,2)==2); 
    test_data.bus(bus_id,7) = test_data.bus(bus_id,7)+(test_data.bus(bus_id,7).*1.5);  %% Add some load
    for ps = 1:size(Gwo,1)    
        a1(ps) = Gwo(ps,bs).bf;
        a2(ps) = Woa(ps,bs).bf;
        a3(ps) = Da(ps,bs).bf;
        a4(ps) = Fpa(ps,bs).bf;
        a5(ps) = Jy(ps,bs).bf;
        a6(ps) = Prop(ps,bs).bf;
        a7(ps) = Atom3(ps,bs).bf;

        bs1{1} = Gwo(ps,bs).bs(end,:);
        n_pos = length(bs1{1})/2;
        bs1{1} = check(test_data,bs1{1},n_pos);
        bs1{2} = Woa(ps,bs).bs(end,:);
        bs1{2} = check(test_data,bs1{2},n_pos);
        bs1{3} = Da(ps,bs).bs(end,:);
        bs1{3} = check(test_data,bs1{3},n_pos);
        bs1{4} = Fpa(ps,bs).bs(end,:);
        bs1{4} = check(test_data,bs1{4},n_pos);
        bs1{5} = Jy(ps,bs).bs(end,:);
        bs1{5} = check(test_data,bs1{5},n_pos);
        bs1{6} = Prop(ps,bs).bs(end,:);
        bs1{6} = check(test_data,bs1{6},n_pos);
        bs1{7} =abs( Atom3(ps,bs).bs(end,:));
        bs1{7} = check(test_data,bs1{6},n_pos);
%         bs1{7} = Atom1(ps,bs).bs(end,:);
%         bs1{7} = check(test_data,bs1{6},n_pos);
        for i = 1:length(bs1)
           [fit(i),soln,cc(ps,i),ls(ps,i)] = obj_fun(bs1{i});
        end
               
        if ps == 4
            bs1n{1} = Gwo(ps,bs).bs;
            bs1n{2} = Woa(ps,bs).bs;
            bs1n{3} = Da(ps,bs).bs;
            bs1n{4} = Fpa(ps,bs).bs;
            bs1n{5} = Jy(ps,bs).bs;
            bs1n{6} = Prop(ps,bs).bs;  
            bs1n{7} = Atom3(ps,bs).bs
           
            conjestn_mng(bs1n,bs)                         
            
            figure
            plot(Gwo(ps,bs).fit,'r','Linewidth',2); hold on
            plot(Woa(ps,bs).fit,'b','Linewidth',2)
            plot(Da(ps,bs).fit,'g','Linewidth',2)
            plot(Fpa(ps,bs).fit,'m','Linewidth',2)
            plot(Jy(ps,bs).fit,'c','Linewidth',2)
            plot(Prop(ps,bs).fit,'k','Linewidth',2)
            plot(Atom3(ps,bs).fit,'','Linewidth',2)
            set(gca,'Fontsize',10)
            h = legend('GWO','WOA','DA ','FPA','Jaya','JA-FPA','Atom');
%             set(h,'fontsize',14,'Location','Best');
            xlabel('Iterations','fontsize',16)
            ylabel('Fitness Functions','fontsize',16)
%             print('-dtiff','-r300',['.\Results\', 'Convergence--',num2str(bs)])
        end
%         disp('Best Solution');
%         T = table(bs1{1}',bs1{2}',bs1{3}',bs1{4}',bs1{5}',bs1{6}');
%         T.Properties.VariableNames = {'GWO','WOA','DA','FPA','Jaya','Prop'};
%         disp(T) 
    end
end
%     disp('Total Cost');
%     vl = [2 3 4 5]';
%     T = table(vl,a1',a2',a3',a4',a5',a6');
%     T.Properties.VariableNames = {'TCSC_no','GWO','WOA','DA','FPA','Jaya','Prop','Atom'};
%     disp(T)    
%     
%     disp('Conjestion Cost');
%     vl = [2 3 4 5]';
%     T = table(vl,cc(:,1),cc(:,2),cc(:,3),cc(:,4),cc(:,5),cc(:,6));
%     T.Properties.VariableNames = {'TCSC_no','GWO','WOA','DA','FPA','Jaya','Prop','Atom'};
%     disp(T)   
%     
%     disp('Loss Cost');
%     vl = [2 3 4 5]';
%     T = table(vl,ls(:,1),ls(:,2),ls(:,3),ls(:,4),ls(:,5),ls(:,6));
%     T.Properties.VariableNames = {'TCSC_no','GWO','WOA','DA','FPA','Jaya','Prop','Atom'};
%     disp(T)   
end
% end


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


function[] = conjestn_mng(bs1,bs)
a1 = {'GWO based Cong.Mgmt','WOA based Cong.Mgmt','DA based Cong.Mgmt'...
      'FPA based Cong.Mgmt','Jaya based Cong.Mgmt','JA-FPA based Cong.Mgmt'};
for i = 6    
    [pV,zcongV] = vltg_calc(bs1{i}(end,:));
    Vmin = 0.95;
    Vmax = 1.06;
    plotvmin = repmat(Vmin,[1 length(pV)]);
    plotvmax = repmat(Vmax,[1 length(pV)]);
%     figure,
%     plot(1:length(pV),zcongV','ms','LineWidth',2,'MarkerSize',10);  %% 
%     hold on
%     plot(1:length(pV),pV','rd','LineWidth',2,'MarkerSize',10);  %% 
%     [r1,c1] = find(pV>Vmax);
%     [r2,c2] = find(pV<Vmin);
%     if isempty(r1)~=1
%         plot(r1',pV(r1),'ro','MarkerSize',20,'LineWidth',2);
%     end
%     if isempty(r2)~=1
%         plot(r2',pV(r2),'ro','MarkerSize',20,'LineWidth',2);
%     end
%     plot(1:length(pV),plotvmin,'--k');  %% Plotted Minimum voltage margin
%     text(1,Vmin,'Minimum Margin','HorizontalAlignment','center','BackgroundColor',[.7 .9 .7]);
%     plot(1:length(pV),plotvmax,'--k');  %% Plotted Minimum voltage margin
%     text(1,Vmax,'Maximum Margin','HorizontalAlignment','center','BackgroundColor',[.7 .9 .7]);
%     h = legend('Before Cong.Mgmt',a1{i},'Congested Bus','Location','Best');
%     set(h,'fontsize',12);
%     grid on
%     xlabel('Bus IDs','fontsize',16);ylabel('Stability Margin','fontsize',20);
%     set(gca,'fontsize',16);
%     hold off
%     print('-dtiff','-r300',['.\Results\', 'congMngt','--',num2str(bs),'--',num2str(i)])
end
end

function[V,v1] = vltg_calc(sol)
global test_data bus_system
test_data1 = test_data;     
busdata = test_data1.bus;
[n_bus,n_busdata] = size(busdata);
branch_data = test_data1.branch;
[n_branch,n_branchdata] = size(branch_data);
    
[bus_id,bus_type] = find(test_data1.bus(:,2)==2); 
test_data1.bus(bus_id,7) = test_data1.bus(bus_id,7)+(test_data1.bus(bus_id,7).*1.5);  %% Add some load

[v1,Pi,Qi,Pg,Qg,Pl,Ql,Lpij,Lqij] = nrl_pf(bus_system,test_data1);
      

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
end