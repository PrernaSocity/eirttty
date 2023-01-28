function [cost] = fualcost(chromo)

% Cost Fitness...

cost_coeff = [0 2.00 0.0038
    0 1.75 0.0175
    0 1.00 0.0625
    0 3.25 0.0083
    0 3.00 0.0250
    0 3.00 0.0250];
cost = 0;

for i = 1:length(chromo)
    PG = chromo(i);
    tcost = (cost_coeff(i,1)+(cost_coeff(i,2)*PG)+(cost_coeff(i,3)*(PG^2)));
    cost = cost + tcost;
end
