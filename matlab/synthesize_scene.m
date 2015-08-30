addpath voxel-utils
addpath voxel-utils/polygonstuff

path = '../data/uw-scenes/objects_3dwarehouse/pc/';
% cls_D = dir(path);
% isub = [cls_D(:).isdir]; %# returns logical vector
% cls_D = {cls_D(isub).name}';
% cls_D(ismember(cls_D,{'.','..'})) = [];
% cls = {'bowl', 'cap', 'cereal_box', 'coffee_mug', 'soda_can'};
cls = {'coffee_table', 'office_chair', 'sofa', 'table'};
s = struct([]);
for i=1:size(cls,2)
    obj_D = dir(fullfile(path,cls{i},'*0.ply'));
    base_mdl = ply_read(fullfile(path,cls{i},obj_D(1).name));
    s(end+1,1).verts(:,1) = base_mdl.vertex.x;
    s(end,1).verts(:,2) = base_mdl.vertex.y;
    s(end,1).verts(:,3) = base_mdl.vertex.z;
    s(end,1).cls = i;
end




grid = 2;
clear scene
scene.limx = [-grid -grid grid grid];
scene.limy = [-grid grid grid -grid];
scene.obj = struct([]);
scene.obj

% convention
% % %   bb(1,:) = [minx minx maxx maxx];
% % %   bb(2,:) = [miny maxy maxy miny];


rng(0);
% min_num = 3;
% max_num = 6;
% num_obj = randi(max_num-min_num)+min_num;
num_obj = 8;
obj_count = 0;
clf
while obj_count < num_obj
  rand_idx = randi(size(s,1));
  v = s(rand_idx,1).verts(:,:);
  bb = get_bounding_verts(v);
  size_bb_x = abs(bb(1,1) - bb(1,3));
  size_bb_y = abs(bb(2,1) - bb(2,3));
  offset_x = 2*(grid - size_bb_x/2)*rand(1,1) - (grid - size_bb_x/2);
  offset_y = 2*(grid - size_bb_y/2)*rand(1,1) - (grid - size_bb_y/2);
  d = [offset_x offset_y];
  new_bb = bb + repmat(d',[1 4]);
  draw_scene_bb(scene, new_bb, grid);
  if size(scene.obj,2) == 0 || can_add_to_scene(scene.obj, new_bb)
    scene.obj(end+1).obb = bb + repmat(d',[1 4]);
    scene.obj(end).v = v + repmat([d(1) d(2) 0], [size(v,1) 1]);
    scene.obj(end).cls = rand_idx;
    obj_count = obj_count + 1;
  end
end

% hold off
% for i=1:size(scene.obj,2)
%   plot([scene.obj(i).obb(1,:) scene.obj(i).obb(1,1)], ...
%       [scene.obj(i).obb(2,:) scene.obj(i).obb(2,1)]);
%   xlim([-grid grid])
%   ylim([-grid grid])
%   hold on
% end

hold off
for i=1:size(scene.obj,2)
  plot3(scene.obj(i).v(:,1), scene.obj(i).v(:,2), scene.obj(i).v(:,3), '.');
  xlim([-grid grid])
  ylim([-grid grid])
  zlim([0 grid])
  hold on
end

