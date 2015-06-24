clear all
num_scenes = 12;

for i=1:num_scenes
    scene = num2str(i,'%02d');
    load(['rot_plys/' scene '_rot.mat']);

    V = V - min(min(V));
    V = V ./ max(max(V));

    dim = 80;
    V = V * dim;
    V = floor(V)+1;
    V(V>dim) = dim;

    vox = zeros(dim,dim,dim);
    idx = sub2ind(size(vox),V(:,1),V(:,2),V(:,3));
    vox(idx) = 1;

    y = zeros(dim,dim,dim);
    y(idx) = labels;

    % % % cut off empty regions
    % [X,Y,Z]=ind2sub(size(vox),find(vox(:)));
    % cutoff_dim = 20;
    % % mins = int32(floor([min(X),min(Y),min(Z)]/cutoff_dim)*cutoff_dim) + 1;
    % % maxes = int32(ceil([max(X),max(Y),max(Z)]/cutoff_dim)*cutoff_dim);
    % % % mins = [1 1 41];
    % % % maxes = [80 80 60];
    % vox = vox(mins(1):maxes(1),mins(2):maxes(2),mins(3):maxes(3));
    % y = y(mins(1):maxes(1),mins(2):maxes(2),mins(3):maxes(3));

    clf
    figure(1)
    show_vox(y,10,true);
    axis([0 size(vox,1) 0 size(vox,2) 0 size(vox,3)])
    pause()
    save(['scene_data/' scene '_data.mat'],'vox','y');
end


for i=1:num_scenes
    load(['scene_data/' num2str(i,'%02d') '_data.mat']);
    X(:,:,:,i) = vox;
    Y(:,:,:,i) = y;
end
save(['scene_data/' 'scenes_mini.mat'],'X','Y');
