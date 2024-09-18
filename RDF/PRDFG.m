clear 
clc
xx=[0];
fprintf("-----LOADING!-----\n\n");
for xxx=1:length(xx)
  fprintf('\n P = %d\n',xx(xxx));
  fid=fopen(strcat(int2str(xx(xxx)),'.dat'));
  p1=fopen(strcat('PBXT',int2str(xx(xxx)),'.dat'),'w');
%   p2=fopen(strcat('PBXT',int2str(xx(xxx)),'.dat'),'w');
  PRDFS;
  fclose all;
end
fprintf("\n\n-----DONE!---");
