function Potential=LJPotential(Atom1,Atom2,Iteration,Max_Iteration,s)
 %Calculate LJ-potential
r=norm(Atom1-Atom2);  
c=(1-(Iteration-1)/Max_Iteration).^3;  
%g0=1.1;
%u=1.24;
rsmin=1.1+0.1*sin(Iteration/Max_Iteration*pi/2);
rsmax=1.24;
if r/s<rsmin
    rs=rsmin;
else
    if  r/s>rsmax
        rs=rsmax;  
    else
        rs=r/s;
    end
end           
 
Potential=c*(12*(-rs)^(-13)-6*(-rs)^(-7)); 