addpath voxel-utils
addpath voxel-utils/polygonstuff

path = '../data/uw-scenes/objects_3dwarehouse/pc/';
% cls_D = dir(path);
% isub = [cls_D(:).isdir]; %# returns logical vector
% cls_D = {cls_D(isub).name}';
% cls_D(ismember(cls_D,{'.','..'})) = [];
% cls = {'bowl', 'cap', 'cereal_box', 'coffee_mug', 'soda_can'};
cls = {'coffee_table', 'office_chair', 'sofa', 'table'};
% s = struct([]);
objects = struct([]);
for i=1:size(cls,2)
    d = dir(fullfile(path,cls{i},'*.ply'));
    for j=1:size(d,1)
      objects(end+1,1).name = d(j).name;
      objects(end,1).cls = i;
    end
end

grid = 2;
clear scene
scene.limx = [-grid -grid grid grid];
scene.limy = [-grid grid grid -grid];
scene.obj = struct([]);

% convention
% % %   bb(1,:) = [minx minx maxx maxx];
% % %   bb(2,:) = [miny maxy maxy miny];

% rng(0);
min_num = 5;
max_num = 10;
num_obj = randi(max_num-min_num)+min_num;
obj_count = 0;
while obj_count < num_obj
  rand_idx = randi(size(objects,1));
  mdl = ply_read(fullfile(path,cls{objects(rand_idx).cls},...
      objects(rand_idx,1).name));
  v = zeros(size(mdl.vertex.x,1),3);
  v(:,1) = mdl.vertex.x; v(:,2) = mdl.vertex.y; v(:,3) = mdl.vertex.z;
  bb = get_bounding_verts(v);
  size_bb_x = abs(bb(1,1) - bb(1,3));
  size_bb_y = abs(bb(2,1) - bb(2,3));
  max_size = max(size_bb_x, size_bb_y); %to prevent edge clipping when rotated
  offset = 2*(grid - max_size/2)*rand(2,1) - (grid - max_size/2);
  
  tr.X = offset(1); tr.Y = offset(2); tr.Z = 0;
  rt.X = 0; rt.Y = 0; rt.Z = rand(1,1)*360;
  sc_min = 0.8; sc_max = 1.2; sc = rand(1,1)*(sc_max-sc_min) + sc_min;
  [new_v, new_bb] = transform_verts(v, bb, rt, tr, sc);
  figure(1); clf;
  draw_scene_bb(scene, new_bb, grid);
  if size(scene.obj,2) == 0 || can_add_to_scene(scene.obj, new_bb)
    scene.obj(end+1).obb = new_bb;
    scene.obj(end).v = new_v;
    scene.obj(end).cls = objects(rand_idx).cls;
    obj_count = obj_count + 1;
  end
end

% %% Show point clouds
% hold off
% clrmap = colormap(parula(size(cls,2)));
% for i=1:size(scene.obj,2)
%   plot3(scene.obj(i).v(:,1), scene.obj(i).v(:,2), scene.obj(i).v(:,3), ...
%     '.', 'Color', clrmap(scene.obj(i).cls,:));
%   xlim([-grid grid])
%   ylim([-grid grid])
%   zlim([0 1.5])
%   hold on
% end


%% Create voxels
V = zeros(0,3);
labels = zeros(0,1);
for i=1:size(scene.obj,2)
  n = size(scene.obj(i).v,1);
  V(end+1:end+n,:) = scene.obj(i).v;
  labels(end+1:end+n,1) = repmat(scene.obj(i).cls,[n 1]);
end
dim = 80;
V = V - min(min(V));
V = V ./ max(max(V));
V = V * dim;
V = floor(V)+1;
V(V>dim) = dim;
x = zeros(dim,dim,dim);
idx = sub2ind(size(x),V(:,1),V(:,2),V(:,3));
x(idx) = 1;
y = zeros(dim,dim,dim);
y(idx) = labels;

% % Cutoff regions
% [~,~,subZ]=ind2sub(size(x),find(x(:)));
% minZ = min(subZ(:));
% maxZ = max(subZ(:));
% x = x(:,:,minZ:maxZ);
% y = y(:,:,minZ:maxZ);

show_vox(y,size(cls,2),true);

