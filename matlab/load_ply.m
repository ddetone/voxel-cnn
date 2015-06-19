scene = '04';

% Load scene
Elements = ply_read(['../data/rgbd-scenes-v2/pc/' scene '_rot.ply']);
verts = Elements.vertex;
clear Elements
V = [verts.x verts.y verts.z];

% Load labels
N = size(V,1);
labels = zeros(N,1);
fid = fopen(['../data/rgbd-scenes-v2/pc/' scene '.label']);
tline = fgetl(fid);
if N ~= str2num(tline)
    disp('num points must correspond')
else
    tline = fgetl(fid);
    for i=1:N
        labels(i) = str2num(tline);
        tline = fgetl(fid);
    end
end
fclose(fid);
save(['rot_plys/' scene '_rot.mat'], 'V', 'labels');
