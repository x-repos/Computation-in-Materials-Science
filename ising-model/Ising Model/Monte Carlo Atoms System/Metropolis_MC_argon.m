
%Program to do a simulation of Model 1D consiting of two atoms, 
%calculate the distance between the atoms using the Lennard-Jones potential,
%Here potential: U=4*epsilon*((sigma/R)^12-(sigma/R)^6)% 
%We work with Argon
clear
clf;
KT=0.1e-02;% Kb*T  kB = 1,38(24).10-23 J/K = 8,617(15).10-5 eV/K; Room Temperature KbT=0.0259 eV
eps=0.01042332e0; %eV; for Ar:eps=16.7e-22J=0.010423320603 eV; sig=3.4
sig=3.4; %Angstroms
%eps=0.0031; %eV; For Ne: eps=5e-22J=0.0031eV; sig=2.74
%sig=2.77; %Angstroms
U=@(eps,sig,r) 4*eps*((sig./r).^12-(sig./r).^6);%Define the LJ potential as an anonymous function
Rguess=4*sig;
Rold=Rguess; %guess starting distance in terms of sigma
Uold=U(eps,sig,Rold); %starting energy
cmod=0.25; %moderator for the random number used below
tol=1.e-6*eps; %convergence tolerance
itermax=1000; %maximum iterations
diffU=10*tol;
% plot(0,0,'Ko','MarkerSize',15,'MarkerFaceColor','k'); hold on
hold on
axis([-1 6*sig -1 1])
% plot(Rold,0,'bo','MarkerSize',15,'MarkerFaceColor','b')
iter=0;
%continue from previous
Uarray=[];
while (diffU > tol && iter < itermax)
iter=iter+1;
cla % clera  axes
% h(1)=plot(0,0,'bo','MarkerSize',12,'MarkerFaceColor','b','markeredgecolor','black');
rn=(-1+2*rand()); %random number -1 < r < 1
Rnew=Rold*(1+cmod*rn); %new R based on rand #, with moderation
Unew=U(eps,sig,Rnew); %new energy
Uarray=[Uarray,Uold];
diffU=abs(Unew-Uold)/abs(Unew+Uold);
%================================
if Unew>Uold
    P=exp(-(Unew-Uold)/KT);
else
    P=1;
end
%=================================
if(rand<P)
Rold=Rnew;
Uold=Unew;
diffUold=diffU;
% h(2)=plot(Rold,0,'ro','MarkerSize',12, 'MarkerFaceColor','r','markeredgecolor','black');
pause(0.1)
end
end
% h(2)=plot(Rold,0,'rO','MarkerSize',12,'MarkerFaceColor','r','markeredgecolor','black');
h(3)=line([0,Rold],[0,0],'LineStyle','--','Color','b');
fprintf('diffU=%8.3e, Min U=%9.6f (eV), R=%9.6f (A), iter=%6i\n',...
diffUold,Uold,Rold,iter)
Ns=300;
rlo=0.1*Rold;
rhi=3.0*Rold;
rs=(rhi-rlo)/(Ns-1);
r=rlo:rs:rhi;
Ur=U(eps,sig,r);
Umin=min(Ur);
for i =1:length(Ur)
  if Ur(i)==Umin
    r0=r(i);
  end
end
% h(4)=plot(r,Ur,'B-');
dashlinex=zeros(1,0);
dashliney=zeros(1,0);
dashlinex(1)=r0;
dashlinex(2)=r0;
dashliney(1)=Umin;
dashliney(2)=0;
% plot(dashlinex,dashliney,'black-.');
axis([-1 4*Rguess Umin abs(Umin)])
xlabel('r (\AA)','interpreter','latex')
ylabel('U (eV)')
str=cat(2,'Monte-Carlo Lennard-Jones U(r) Simulation:',' Umin=',...
num2str(Umin,'%9.4g'),'eV, R=',num2str(Rold,'%9.4g'),'A');
title(str)
% legend(h,{'origin atom','other atom','common bond','L-J: Potential'})

xlim([0,15]);
step=1:iter;
figure;
plot(step,Uarray)

