dataset = 'mdb10_dim20_100tr';
load(['../data/' dataset '.mat'])
X = mdb.data;
y = mdb.class;

aug.num = 12;
aug.deg = 30;
aug.noise = 3;

% Repeat labels num times
y_aug = repelem(y,aug.num,1);

% Data augmentation via random rotations
X_aug = zeros(size(repelem(X,1,1,1,aug.num)));
for i=1:size(X,4)
    for j=1:aug.num
        deg = floor(aug.deg*j + aug.noise*randn(1));
        idx = (i-1)*aug.num + j;
        disp(sprintf('idx is: %d \t of %d', idx, ...
            aug.num*size(X,4)));
        X_aug(:,:,:,idx) = rotate_vox(X(:,:,:,i), ...
            aug.noise*randn(1), aug.noise*randn(1),deg,true);
    end
end

X = X_aug;
y = y_aug;
% save(['../data/' dataset '_aug.mat'],'X','y','aug');