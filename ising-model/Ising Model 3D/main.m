clc; 

clear all 

fp=fopen('magnetization_2017.dat','w'); 

%config Dx=14; Dy=14 

Dx=6; 

Dy=6; 

Dz=6; 

NN=Dx*Dy*Dz; 

Tmax=10;T=0.2; 

Ntran=10; 

Nmax=1000; kk=0; M1=[]; CHI=[]; CV=[]; 

while T<Tmax 

if ((T>2.1)&(T<2.6)) 

dT=0.05; 

else 

dT=0.2; 

end 

% iput the parameter 

T=T+dT; c0=1.0/T; initial_state; % call program initial_state to generate the initial state 

for j=1:Ntran 

for t=1:NN 

flip_sp; % Call the the program: flip_spin to change the spin orientation 

end 

end 

for i=1:Nmax 

for t=1:NN 

flip_sp; % Call the the program: flip_spin to change the spin orientation 

end 

Emed=Emed+Ener; 

Mmed=Mmed+Mag; 

if (Mag>0) MMM=MMM+Mag; 

else MMM=MMM-Mag; 

end 

Emed2=Emed2+Ener*Ener; 

Mmed2=Mmed2+Mag*Mag; 

end 

kk=kk+1; 

T1(kk)=T; 

Mmed=Mmed/Nmax; 

MMM=MMM/Nmax/NN; 

Mmed2=Mmed2/Nmax; 

Emed=Emed/Nmax; 

Emed2=Emed2/Nmax; 

Cv=(Emed2-Emed*Emed)/T/T/NN; 

chi=(Mmed2-Mmed*Mmed)/T/NN; 

M1=[M1,MMM]; CV=[CV,Cv]; CHI=[CHI, chi]; 

fprintf(fp,' %f %f %f %f %f\n', T, MMM, Cv, chi, Ener/NN); 

end 

figure(1), plot(T1, M1, 'blacko'), title('Magnetization');xlabel('T');ylabel('M'); 

figure(2), plot(T1, CV, 'blacko'), title('Specific heat');xlabel('T');ylabel('CV'); 

figure(3),plot(T1, CHI, 'blacko'), title('Succeptibbility');xlabel('T');ylabel('CHI'); 

fclose all 