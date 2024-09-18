function [x_left, x_right, y_left, y_right]=Periodic_Boundary(K1, K2, Dx, Dy)
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
if y_right>Dx
y_right=1;
end