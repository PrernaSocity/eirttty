function [gen_data] = cost_coeff(num)

%% Capacity and cost coecients - IEEE 14 bus system
%               Generator   Pimin       Pimax       ai          bi          ci 
%               number      (MW)        (MW)        $/MWhr2     $/MWhr      $/hr
%------------------------------------------------------------------------------------------------
cap_cost14 = [...
                1           10          160         0.005       2.450       105.000
                2           20          80          0.005       3.510       44.100
                3           20          50          0.005       3.890       40.600];
                              
cap_cost30 = [...
               1	        50	        200	        0.00375	     2.00	     0	
               2	        20	         80	        0.01750	     1.75	     0	
               3	        15	         50	        0.06250    	 1.00	     0	
               4	        10	         35	        0.00834	     3.25	     0	
               5	        10	         30	        0.02500	     3.00	     0	
               6	        12	         40	        0.02500	     3.00	     0];
%% Accessing system data           
switch (num)
    case 14
        gen_data = cap_cost14;
    case 30
        gen_data = cap_cost30;
    case 57
        gen_data = cap_cost57;
end