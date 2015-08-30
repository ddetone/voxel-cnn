function [ can_add ] = can_add_to_scene( obj_list, new_bb )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

  for i=1:size(obj_list,2)
    if isintersect(obj_list(i).obb(1:2,:), new_bb)
      can_add = false;
      return;
    end
  end
  can_add = true;
end

