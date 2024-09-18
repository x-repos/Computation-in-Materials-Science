% creat the initial paramaters and state configuration 

Emed=0; Emed2=0; Mmed=0; Mmed2=0; MMM=0;Mg=0 ; 

Msp=zeros(Dx,Dy,Dz); Msp=round(rand(Dx,Dy,Dz))*2-1; 

Mag=sum(sum(sum(Msp))); 

Ener=0; 

  

for K1=1:Dx 

for K2=1:Dy 

for K3=1:Dz 

[x_left, x_right, y_left, y_right, z_left, z_right]=Periodic_Boundary(K1, K2,K3, Dx, Dy,Dz); 

Ener=Ener-Msp(K1,K2,K3)*(Msp(x_left,K2,K3)+Msp(x_right,K2,K3) +Msp(K1,y_left,K3)+ Msp(K1,y_right,K3)+Msp(K1,K2,z_left)+ Msp(K1,K3,z_right)); 

end 

end 

end 

Ener=Ener/2; 

 