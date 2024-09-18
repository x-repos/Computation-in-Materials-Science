% creat the initial paramaters and state configuration
Emed=0; Emed2=0; Mmed=0; Mmed2=0; MMM=0;Mg=0 ;
Msp=zeros(Dx,Dy); Msp=round(rand(Dx))*2-1;
Mag=sum(sum(Msp));
Ener=0;
for K1=1:Dx
for K2=1:Dy
[x_left, x_right, y_left, y_right]=Periodic_Boundary(K1, K2, Dx, Dy);
Ener=Ener-Msp(K1,K2)*(Msp(x_left,K2)+Msp(x_right,K2) +Msp(K1,y_left)+ Msp(K1,y_right));
end
end
Ener=Ener/2