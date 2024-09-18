x=round(rand*(Dx-1))+1;
y=round(rand*(Dy-1))+1;
z=round(rand*(Dz-1))+1;

spin=Msp(x,y,z);
[x_left, x_right, y_left, y_right]=PeriodicBoundary(k1,k2,k3,Dx,Dy,Dz);
sum_sp=(Msp(x_left, y,z)+Msp(x_right,y,z)+Msp(x,y_left,z)+Msp(x,y_right,z)...
  +Msp(x,y,z_left)++Msp(x,y,z_right));
DE=2*spin*sum_sp;
if DE>0
p=exp(-c0*DE);
else
p=1 ;
end
r=rand;
if r<=p
Msp(x, y) =-spin;
Mag=Mag-2*spin; % calculate M
Ener=Ener+DE; % calculate Energy
end