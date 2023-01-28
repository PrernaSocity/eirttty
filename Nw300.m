load busdata.mat
load V_3.mat
load const.mat
load pg.mat
load r.mat
load s2.mat

Max_Iteration=1000;
Atom_Num=busdata_300(:,1:10);
alpha=50;
beta=0.2;
Fun_Index=1;
[X_Best,Fit_XBest,His_Fit]=ASO1(alpha,beta,Fun_Index,Atom_Num,Max_Iteration);
display(['F_index=', num2str(Fun_Index)]);
display(['The best fitness is: ', num2str(Fit_XBest)]);