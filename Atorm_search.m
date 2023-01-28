clc;
clear all;
close all;
warning off
addpath('nrlfppg');
load busdata.mat
pos = [2 3 4 5];  % number of best positions
bus_sys = [30 118 300]; %% Bus systems used

[X_Best,Fit_XBest,His_Fit]=ASO(alpha,beta,Fun_Index,Atom_Num,Max_Iteration);

