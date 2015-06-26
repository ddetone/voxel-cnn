clear all
num_scenes = 14;
pad = 0; %pad the label
scene_mat = 'scene_data/scenes.mat';
show_scenes = false;
dim = 80;

% Data augmentation parameters
aug.do = false;
aug.num = 1;
aug.rdeg = 180;
aug.rnoise_xy = 0;
aug.rnoise_z = 0;
aug.smax = 1;       %scale randomly between 50-200% [unif]
aug.smin = 1;
aug.tmax = 1*dim; %translate randomly btwn (-tmax*dim)-(tmax*dim) [unif]

% for i=1:num_scenes
%     scene = num2str(i,'%02d');
%     load(['rot_plys/' scene '_rot.mat']);
% 
%     V = V - min(min(V));
%     V = V ./ max(max(V));
% 
%     V = V * dim;
%     V = floor(V)+1;
%     V(V>dim) = dim;
% 
%     x = zeros(dim,dim,dim);
%     idx = sub2ind(size(x),V(:,1),V(:,2),V(:,3));
%     x(idx) = 1;
% 
%     y = zeros(dim,dim,dim);
%     y(idx) = labels;
% 
%     % % % cut off empty regions
%     % [X,Y,Z]=ind2sub(size(vox),find(vox(:)));
%     % cutoff_dim = 20;
%     % % mins = int32(floor([min(X),min(Y),min(Z)]/cutoff_dim)*cutoff_dim) + 1;
%     % % maxes = int32(ceil([max(X),max(Y),max(Z)]/cutoff_dim)*cutoff_dim);
%     % % % mins = [1 1 41];
%     % % % maxes = [80 80 60];
%     % vox = vox(mins(1):maxes(1),mins(2):maxes(2),mins(3):maxes(3));
%     % y = y(mins(1):maxes(1),mins(2):maxes(2),mins(3):maxes(3));
%     
%     % cut off ground plane
%     
%     [~,~,subZ]=ind2sub(size(x),find(x(:)));
%     minZ = min(subZ(:));
%     cutoff = 0;
%     while 1
%         cutoff = cutoff + 1;
%         x(:,:,1:minZ+cutoff) = 0;
%         y(:,:,1:minZ+cutoff) = 0;
%         clf
%         figure(1)
%         show_vox(y,10,true);
%         axis([0 size(y,1) 0 size(y,2) 0 size(y,3)])
%         in = input('continue? y/n','s');
%         if strcmp(in, 'n')
%             break;
%         elseif strcmp(in, 'y') == false
%             cutoff = cutoff - 1;
%         end 
%     end
% 
% %     % pad labels
% %     y_pad = zeros(dim+2*pad, dim+2*pad, dim+2*pad);
% %     y_pad(pad+1:end-pad, pad+1:end-pad, pad+1:end-pad) = y;
% %     y = y_pad;
% %     
% %     % data augmentation on scenes
% %     if aug.do
% %         y_aug = zeros(size(y,1),size(y,2),size(y,3),aug.num);
% %         x_aug = zeros(size(x,1),size(x,2),size(x,3),aug.num);
% %         for j=1:aug.num
% %             rot.X = aug.rnoise_xy*randn(1);
% %             rot.Y = aug.rnoise_xy*randn(1);
% %             deg = floor(aug.rdeg*j + aug.rnoise_z*randn(1));
% %             rot.Z = deg;
% %             tr.X = 2*aug.tmax*(rand(1,1)-0.5);
% %             tr.Y = 2*aug.tmax*(rand(1,1)-0.5);
% %             tr.Z = 2*aug.tmax*(rand(1,1)-0.5);
% %             sc = (aug.smax-aug.smin)*rand(1,1)+aug.smin;
% %             y_aug(:,:,:,j) = rotate_vox(y,rot,tr,sc,false);
% %             x_aug(:,:,:,j) = rotate_vox(x,rot,tr,sc,false);
% %         end
% %     end
%     
%     if show_scenes && aug.do == false
%         clf
%         figure(1)
%         show_vox(y,10,true);
%         axis([0 size(y,1) 0 size(y,2) 0 size(y,3)])
%         pause()
%     end
%     
%     if aug.do
%         y = y_aug;
%         x = x_aug;
%     end
%     
%     save(['scene_data/' scene '_data.mat'],'x','y');
%     disp(['processed scene: ' num2str(i)]);
% end

X = zeros(dim,dim,dim,num_scenes*aug.num);
Y = zeros(dim+2*pad,dim+2*pad,dim+2*pad,num_scenes*aug.num);
for i=1:num_scenes
    load(['scene_data/' num2str(i,'%02d') '_data.mat']);
    X(:,:,:,(i-1)*aug.num+1:i*aug.num) = x;
    Y(:,:,:,(i-1)*aug.num+1:i*aug.num) = y;
end
save(scene_mat,'X','Y');
