% clear;clc;
SizeG=1200;
% fid=fopen(strcat(int2str(xx(xxx)),'.xyz'));
% fid=fopen('U0.xyz');

A1=fscanf(fid,'%d  %f',[2 1]);
l=A1(2,1); n=A1(1,1);
A=fscanf(fid,'%d %f %f %f %f %d',[6 n]);
A=A';


%% Input
x=A(:,2);
y=A(:,3);
z=A(:,4);
c=A(:,6);
lx=max(x)-min(x); ly=max(y)-min(y); lz=max(z)-min(z);
n1=sum(c==1);  % Si
n2=sum(c==2);  % Oxy
n3=sum(c==3);  % Mg

%% Caculation
gav=zeros(SizeG, 1);
g=zeros(SizeG, 1);
dg=0.03; lm=dg*(SizeG-1);
if lm>lx/2
  lm=lx/2-dg;
end

for i=1:n-1
  for j=(i+1):n
    r=Dist(x(i), y(i), z(i), x(j), y(j), z(j), lx, ly, lz);
      if(r<lm) 
        k=floor(1+r/dg); 
       
          g(k)=g(k)+1.0;
      end
  end
end
% 
for i=1:SizeG
  g(i)=g(i)/n/(2*pi*dg*dg*i*i*dg+1.e-20)/(n/lx/ly/lz);
  
end

for i=1:SizeG
  R(i)=(i-1)*dg;%Root at 0
end

plot(R,g);

