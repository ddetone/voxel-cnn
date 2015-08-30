function [ bb ] = get_bounding_verts( all_verts )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

  % Bot_left Top_left Top_right Bot_right

  miny = min(all_verts(:,2));
  minx = min(all_verts(:,1));
  maxy = max(all_verts(:,2));
  maxx = max(all_verts(:,1));
  
  % X row 
  bb(1,:) = [minx minx maxx maxx];
  bb(2,:) = [miny maxy maxy miny];

end

