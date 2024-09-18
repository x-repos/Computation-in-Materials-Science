% All the parameters were well adjusted
% but you can change the paras as you wish

% Processing time for 8000 spheres is about 11 minutes

% For the large data, I sugguest to run all process to save F, V
% Then plot later based on saved F, V                   

clear; clc;
datax = readtable('File_cluster_HA.csv'); 
centers = datax(datax.cluster == 42, :); % change cluster here
% centers = datax(datax.cluster == 7, :);

k_para = 0.7; % for alphashape
complex_para = 0.3; % for reducing complexity
n_smooth = 3; % for smoothing
radius = 0.3; % adjust for the radius

% Get the length (number of rows) of centers
num_spheres = height(centers);
disp(num_spheres)
disp("readtable: done")
%% OPTIONAL: PLOTS SPHERES
% Loop through each center and plot the sphere
hold on
for i = 1:num_spheres
    % Extract the center coordinates
    center_x = centers.x(i);
    center_y = centers.y(i);
    center_z = centers.z(i);

    % Generate a sphere
    [X, Y, Z] = sphere(20); % 20 defines the resolution of the sphere

    % Scale the sphere by the desired radius and position it at the center
    X = center_x + radius * X;
    Y = center_y + radius * Y;
    Z = center_z + radius * Z;

    % Plot the sphere
    surf(X, Y, Z, 'FaceColor', 'b', 'EdgeColor', 'none', 'FaceAlpha', 0.5);
end

%%
% 8000 spheres in about 10 minutes
K_centers = boundary(centers.x, centers.y, centers.z, k_para);

faces = K_centers;
vertices = [centers.x, centers.y, centers.z];

num_points = 500; % For surface
tic;
surface_points = [];
for i = 1:num_spheres
    disp(['Processing sphere ', num2str(i), ' of ', num2str(num_spheres)]);
    % Extract the center coordinates (assuming x, y, z are the first three columns)
    center_x = centers.x(i);
    center_y = centers.y(i);
    center_z = centers.z(i);
    u = rand(num_points, 1) * 2 * pi;
    v = rand(num_points, 1) * pi;

    x = center_x + (radius) * cos(u) .* sin(v);
    y = center_y + (radius) * sin(u) .* sin(v);
    z = center_z + (radius) * cos(v);

    in = inpolyhedron(faces, vertices, [x, y, z]);
    surface_points = [surface_points; [x(~in), y(~in), z(~in)]];
end
elapsed_time = toc;  

disp(['Processing time for scatter: ', num2str(elapsed_time), ' seconds']);
%%
% 8000 spheres in about 1 minute
tic;
K = boundary(surface_points, k_para);
elapsed_time = toc;  

disp(['Processing time for boundary: ', num2str(elapsed_time), ' seconds']);
%%
tic;
trisurf(K, surface_points(:, 1), surface_points(:, 2), surface_points(:, 3), ...
    'FaceColor', 'blue', 'EdgeColor', 'black', 'FaceAlpha', 0.9, 'edgealpha', 0);

hold off;
lighting gouraud
camlight
rotate3d on
set(gca,'DataAspectRatio',[ 1 1 1 ])
set(gca,'PlotBoxAspectRatio',[ 1 1 1 ])
set(gca,'CameraViewAngleMode','manual')
set(gcf,'Color',[1 1 1]);                %[0.1 0.2 0.8])
set(gca,'XTick',[])
set(gca,'YTick',[])
set(gca,'ZTick',[])
axis off
elapsed_time = toc;
disp(['Processing time for plotting: ', num2str(elapsed_time), ' seconds']);
%%
% 8000 spheres in about 3 minutes

tic
[F, V] = reducepatch(K, surface_points, complex_para);  % Reduce to 30% of original complexity

% Optional: Apply a custom smoothing algorithm (if smoothpatch is not available)
for iter = 1: n_smooth % Perform 10 smoothing iterations
    disp(iter)
    V = laplacian_smooth(V, F);
end
elapsed_time = toc;  

disp(['Processing time for smoothing: ', num2str(elapsed_time), ' seconds']);
%%
save('F')
save('V')
save('K')
save('surface_points')

%%

% Plot the smoothed trisurf
figure;
trisurf(F, V(:,1), V(:,2), V(:,3), 'FaceColor', 'blue', 'EdgeColor', 'none', 'FaceAlpha', 0.9);

% Adjust the visualization
lighting gouraud
camlight
rotate3d on
axis equal
set(gca,'DataAspectRatio',[1 1 1])
set(gca,'PlotBoxAspectRatio',[1 1 1])
set(gca,'CameraViewAngleMode','manual')
set(gcf,'Color',[1 1 1]);
axis off
%%
function V_new = laplacian_smooth(V, F)
    % Laplacian smoothing algorithm
    V_new = V;
    for i = 1:size(V, 1)
        neighbors = find_neighbors(F, i);
        V_new(i, :) = mean(V(neighbors, :), 1);
    end
end

function neighbors = find_neighbors(F, vertex_index)
    % Find neighboring vertices in the mesh
    neighbors = unique(F(any(F == vertex_index, 2), :));
    neighbors(neighbors == vertex_index) = [];
end
