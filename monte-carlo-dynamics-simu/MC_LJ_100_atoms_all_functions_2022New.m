%%%%%%%%%%%%%%%%%%%%% Program MC for NVT System %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    clear all; close all; clc
    % INPUT parameters for model
    nPart = 1000;            % Number of atoms (particle)
    density = 0.5;          % Density of atoms (particle)
    Temp = 2;             % Simulation temperature
    beta = 1.0/Temp;        % Inverse temperature 
    maxDr = 0.05;           % Maximal displacement
    nSteps = 100;          % Total simulation time (in integration steps)
    printFreq = nSteps/10;  % Printing frequency
    % Set initial configuration
    [coords L] = initCubic(nPart,density);
    energy = LJ_Energy(coords,L);  % Calculate initial energy
    E=zeros(nSteps,1);
    % ============== MC Simulation- main part==============
     for step = 1:nSteps
        if (mod(step,printFreq)==0)
            step;
        end  
%         each MC step involves suggesting nPart times of trial moves 
        for i=1:nPart
            rTrial = coords(:,i) + maxDr*(rand(3,1)-0.5); % Suggest a trial move for particle i   
            rTrial = PBC3D(rTrial,L);                     % Apply periodic boundary conditions
            rTrial = distPBC3D(rTrial,L);                % Apply periodic boundary conditions
            deltaE = LJ_EnergyChange(coords,rTrial,i,L);% Calculate the change in energy due to this trial move
            if (rand < exp(-beta*deltaE))   % Accept displacement move
                coords(:,i) = rTrial;       % Update positions
                energy = energy + deltaE;   % Update energy
            end
        end
%         E(step)=energy;
     end
   
    %================Calculate CV++++++++++++++++++++++++++++++++
    Emed=0; Emed2=0;
    for step = 1:nSteps
        if (mod(step,printFreq)==0)
            step;
        end  
        % each MC step involves suggesting nPart times of trial moves 
        for i=1:nPart
            rTrial = coords(:,i) + maxDr*(rand(3,1)-0.5); % Suggest a trial move for particle i   
            rTrial = PBC3D(rTrial,L);                 % Apply periodic boundary conditions
            %rTrial = distPBC3D(rTrial,L);                % Apply periodic boundary conditions
            deltaE = LJ_EnergyChange(coords,rTrial,i,L);% Calculate the change in energy due to this trial move
            if (rand < exp(-beta*deltaE))   % Accept displacement move
                coords(:,i) = rTrial;       % Update positions
                energy = energy + deltaE;   % Update energy
            end
        end
        E(step)=energy;
        Emed=Emed+energy;
        Emed2=Emed2+energy*energy;
    end
    Eav=Emed/nSteps/nPart;
    CV=(Emed2/nSteps-(Emed/nSteps)*(Emed/nSteps))/Temp/Temp/nPart;
    
    % ========================3D visualization===============   
        [Sx Sy Sz]=sphere(50);
        Ray=0.1; mau=[1 0 0];
        coords=coords';
        x=coords(:,1); y=coords(:,2); z=coords(:,3);
        for i=1:nPart
          surface((Ray*Sx + x(i)),(Ray*Sy + y(i)),(Ray*Sz + z(i)),'FaceColor',mau, 'EdgeColor','none'); 
        end
        % Cubic BOX
        mau3=[0 0 0];
        k1=1; Lx1=min(x); Lx2=max(x);  Ly1=min(y); Ly2=max(y);  Lz1=min(z); Lz2=max(z);  
        line([Lx1, Lx2],[Ly1, Ly1], [Lz1, Lz1],'Color',mau3,'LineWidth',k1*Ray);
        line([Lx1, Lx2],[Ly1, Ly1], [Lz2, Lz2],'Color',mau3,'LineWidth',k1*Ray);
        line([Lx1, Lx2],[Ly2, Ly2], [Lz1, Lz1],'Color',mau3,'LineWidth',k1*Ray);
        line([Lx1, Lx2],[Ly2, Ly2], [Lz2, Lz2],'Color',mau3,'LineWidth',k1*Ray);

        line([Lx2, Lx2],[Ly1, Ly1], [Lz1, Lz2],'Color',mau3,'LineWidth',k1*Ray);
        line([Lx2, Lx2],[Ly2, Ly2], [Lz1, Lz2],'Color',mau3,'LineWidth',k1*Ray);
        line([Lx1, Lx1],[Ly1, Ly1], [Lz1, Lz2],'Color',mau3,'LineWidth',k1*Ray);
        line([Lx1, Lx1],[Ly2, Ly2], [Lz1, Lz2],'Color',mau3,'LineWidth',k1*Ray);

        line([Lx2, Lx2],[Ly1, Ly2], [Lz1, Lz1],'Color',mau3,'LineWidth',k1*Ray);
        line([Lx2, Lx2],[Ly1, Ly2], [Lz2, Lz2],'Color',mau3,'LineWidth',k1*Ray);
        line([Lx1, Lx1],[Ly1, Ly2], [Lz1, Lz1],'Color',mau3,'LineWidth',k1*Ray);
        line([Lx1, Lx1],[Ly1, Ly2], [Lz2, Lz2],'Color',mau3,'LineWidth',k1*Ray);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        view(3)
        camlight
        rotate3d on
        set(gca,'DataAspectRatio',[ 1 1 1 ])
        set(gca,'PlotBoxAspectRatio',[ 1 1 1 ])
        set(gca,'CameraViewAngleMode','manual')
        set(gcf,'Color',[1 1 1]);                %[0.1 0.2 0.8])
        set(gcf,'Name','atomic viewer creat by HONGNV')
        set(gca,'XTick',[])
        set(gca,'YTick',[])
        set(gca,'ZTick',[])
        axis off
        hold off
        %============= plot Energy depends on the numer of simulation steps ======
        St=1:nSteps;
        figure(2); plot(St, E(1:nSteps), 'black-')%  'LineWidth', 3);
        ylabel('Energy');  xlabel('Steps'); 
         %======================Calculate radial Distribution  Fuction  =====
        L=max(x)-min(x);
        SizeG=fix(L/0.02);
        xb=coords(:,1);
        yb=coords(:,2);
        zb=coords(:,3);
        lx=L; ly=L; lz=L;
        %///////////////////////////////////////////////////
        dg=0.02;
        g11=zeros(SizeG, 1); lm=dg*(SizeG-1);
        if lm>lx/2 
            lm=lx/2;
        end
        n=length(xb);
        for i=1:n-1
            for j=(i+1):n
                r=distance_rij(xb(i), yb(i), zb(i), xb(j), yb(j), zb(j), lx, ly, lz);
                if(r<lm) k=round(1+r/dg); 
                 g11(k)=g11(k)+1.0; 
                end
            end
        end
        for i=1:SizeG
            g11(i)=g11(i)/n/(2*pi*dg*dg*i*i*dg+1.e-20)/(n/lx/ly/lz);  
            R(i)=i*dg;
        end

        figure, plot(R*3.4/10, g11, 'LineWidth', 3);
        title('Radial Distribution'); ylabel('g(r)'); xlabel('r/nm')
        xlim([0, 0.6])
        %%%%%%%%%%%%%%%% calculate rij between two atoms++++++++++++++++++++
        function kc=distance_rij(x1, y1, z1, x2, y2, z2, lx, ly, lz)
        rx=abs(x1-x2); if(rx>lx/2)rx=rx-lx;end
        ry=abs(y1-y2); if(ry>ly/2)ry=ry-ly;end
        rz=abs(z1-z2); if(rz>lz/2)rz=rz-lz;end
        kc=sqrt(rx^2+ry^2+rz^2);
        end
        %==============InitCubic_function==========
        function [coords, L] = initCubic(nPart,density)
        coords = zeros(3,nPart); % Initialize with zeroes
        L = (nPart/density)^(1.0/3); % Get the cooresponding box size
        coords=rand(3, nPart)*L;
        end 
    
       %========   Boundary condition====================================
          function vec = distPBC3D(vec,L)
            hL = L/2.0;
            for dim=1:3
                if (vec(dim) > hL)
                    vec(dim) = vec(dim)-L;
                elseif (vec(dim) < -hL)
                    vec(dim) = vec(dim)+L;
                end
            end
          end
      %++++++++++++++++++++++Boundary condition+++++++++++++++++++++++++++++++++++++++
        function vec = PBC3D(vec,L)
            for dim=1:3
                if (vec(dim) > L)
                    vec(dim) = vec(dim)-L;
                elseif (vec(dim) < 0)
                    vec(dim) = vec(dim)+L;
                end

            end
        end  
        %+++++++++++++Energy++++++++++++++++++++++++++
        function energy = LJ_Energy(coords,L)
        energy = 0;
       
        nPart = size(coords,2); % Get the number of particles
        % Loop over all distinct particle pairs
        for partA = 1:nPart-1
            for partB = (partA+1):nPart
                % Calculate particle-particle distance
                dr = coords(:,partA) - coords(:,partB);
                dr = distPBC3D(dr,L);% boundary conditions
                dr2 = sum(dot(dr,dr));% Get the distance squared
                invDr6 = 1.0/(dr2^3); % 1/r^6
                energy = energy + (invDr6 * (invDr6 - 1));
            end
         end
         energy = energy*4;  % Multiply energy by 4
        end
        %+++++++++++++++++Change Engergy======
        function deltaE = LJ_EnergyChange(coords,trialPos,part,L)
        deltaE = 0;
        nPart = size(coords,2);  % Get the number of particles
        % Loop over all particles and calculate interaction with particle 'part'.
        for otherPart = 1:nPart
            % Skip particle 'part' so that we don't calculate selfinteraction
            if (otherPart == part)
                continue
            end   
            % Calculate particle-particle distance for both the old and newconfigurations
            drNew = coords(:,otherPart) - trialPos;
            drOld = coords(:,otherPart) - coords(:,part);
            % Apply Periodic boundary conditions
            drNew = distPBC3D(drNew,L);
            drOld = distPBC3D(drOld,L); 
            % calculate distance squared
            dr2_New = sum(dot(drNew,drNew));
            dr2_Old = sum(dot(drOld,drOld));      
            invDr6_New = 1.0/(dr2_New^3); % 1/r^6
            invDr6_Old = 1.0/(dr2_Old^3); % 1/r^6
            % Calculate the potential energy
            eNew = (invDr6_New * (invDr6_New - 1));
            eOld = (invDr6_Old * (invDr6_Old - 1));
            deltaE = deltaE + eNew - eOld;
         end
        deltaE = deltaE*4;   % Multiply energy by 4
        end
      
       
       %============================================

      