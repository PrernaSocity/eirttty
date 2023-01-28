load busdata.mat
load volt.mat
load Ite.mat
load pg.mat
load const.mat
load s2.mat
Max_Iteration=1000;
Atom_Num=busdat30;
% [m n]=length(Atom_Num);
alpha=50;
beta=0.2;
Fun_Index=1;
[X_Best,Fit_XBest,His_Fit]=ASO(alpha,beta,Fun_Index,Atom_Num,Max_Iteration);
display(['F_index=', num2str(Fun_Index)]);
display(['The best fitness is: ', num2str(Fit_XBest)]);