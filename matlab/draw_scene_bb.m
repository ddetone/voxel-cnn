function draw_scene_bb( scene, newbb, grid)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

hold off
for i=1:size(scene.obj,2)
  plot([scene.obj(i).obb(1,:) scene.obj(i).obb(1,1)], ...
      [scene.obj(i).obb(2,:) scene.obj(i).obb(2,1)],'b');
  hold on
end
plot([newbb(1,:) newbb(1,1)], [newbb(2,:) newbb(2,1)], 'r');
grid = grid + grid*.1;
xlim([-grid grid])
ylim([-grid grid])
end

