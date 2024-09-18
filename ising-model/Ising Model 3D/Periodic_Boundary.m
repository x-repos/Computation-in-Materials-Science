function [x_left, x_right, y_left, y_right,z_left,z_right]=Periodic_Boundary(K1, K2,K3, Dx, Dy, Dz) 

x_left=K1-1; 

if x_left==0 

x_left=Dx; 

end 

x_right=K1+1 ; 

if x_right>Dx 

x_right=1; 

end 

y_left=K2-1; 

if y_left==0 

y_left=Dy; 

end 

y_right=K2+1 ; 

if y_right>Dy 

y_right=1; 

end 

z_left=K3-1; 

if z_left==0 

z_left=Dz; 

end 

z_right=K3+1 ; 

if z_right>Dz 

z_right=1; 

end 