%% README

%% INITIAL

clear;clc;

%% OPEN RINGS
file = fopen('ringsCombine12.dat');
fgetl(file);
fgetl(file);
maxSize=0;
% In the case rings.dat does not end of 0
% Due to errors appearing in command line - LINUX:
% "corrupted size vs. prev_size
% Aborted"
% Add 0 value manually
while true
  readLine=fgetl(file);
  ringType = str2double(strtok(readLine));
  if maxSize < ringType
    maxSize = ringType;
  end
  if ringType == 0
    break
  end
end
halfMaxSize = maxSize/2;
frewind(file)

ringCompt = zeros(1,maxSize+1);
fgetl(file);
fgetl(file);
while true
  ringType = fscanf(file,'%d',1);
  if ringType == 0
    break
  end
  ring = fscanf(file,'%d',[1 ringType]);
  if ring(end) == 0
    break;
  end
  if length(ring) < ringType
    break % Not saved yet due to corrupted size vs. prev_size
  end
  if ringType < maxSize
    for i = 1:maxSize-ringType
      ring=[ring,0]; %#ok
    end
  end
  ring = [ringType,ring]; %#ok
  ringCompt=[ringCompt;ring]; %#ok
end
ringCompt(1,:)=[];

%% RING STATISTIC
file=fopen('ringStatistics.dat','w');
% halfMinSize and halfMaxSize correspond to n-fold ring -T-T-
halfMaxSize   = maxSize/2;
ringStatistix=zeros(1,maxSize);
for i=1:maxSize
  ringStatistix(i)=sum(ringCompt(:,1)==i);
end
k=0;
Fvalue = zeros(1,2);
for i=2:halfMaxSize
  k = k+1;
  Fvalue = [Fvalue; [i,ringStatistix(2*i)]];
  fprintf(file,"%-5d %-5d\n",i,ringStatistix(2*i));
end
Fvalue(1,:) = [];
% Fvalue(:,2)/sum(Fvalue(:,2))*100;
Fvalue(:,2) = Fvalue(:,2)/sum(Fvalue(:,2))*100;
bar(Fvalue(:,1), Fvalue(:,2))
