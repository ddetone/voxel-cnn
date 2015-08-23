% addpath voxel-utils
% 
% path = '../data/uw-scenes/objects_3dwarehouse/pc/';
% cls_D = dir(path);
% isub = [cls_D(:).isdir]; %# returns logical vector
% cls_D = {cls_D(isub).name}';
% cls_D(ismember(cls_D,{'.','..'})) = [];
% s = struct([]);
% for i=1:size(cls_D)
%     obj_D = dir(fullfile(path,cls_D{i},'*0.ply'));
%     base_mdl = ply_read(fullfile(path,cls_D{i},obj_D(1).name));
%     s(end+1,1).verts = base_mdl.vertex;
% end

% v = zeros([],[]);
% v(:,1) = s(1,1).verts.x;
% v(:,2) = s(1,1).verts.y;
% v(:,3) = s(1,1).verts.z;

bb.x = [min(v(:,1)) max(v(:,1))];
bb.y = [min(v(:,2)) max(v(:,2))];

scenebb.x = [-10 10];
scenebb.y = [-10 10];

for i=1:5
    pos = unifrnd(-10,10,[1 2]);
    bb.x = bb.x + pos(1);
    bb.y = bb.y + pos(2);
    
%     scenebb.verts
end
