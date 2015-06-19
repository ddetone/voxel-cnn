load('scenes.mat');

% % Data augmentation via random rotations
% aug.num = 12;
% aug.deg = 30;
% aug.noise = 3;
% X_aug = zeros(size(repelem(X,1,1,1,aug.num)));
% for i=1:size(X,4)
%     for j=1:aug.num
%         deg = floor(aug.deg*j + aug.noise*randn(1));
%         idx = (i-1)*aug.num + j;
%         disp(sprintf('idx is: %d \t of %d', idx, ...
%             aug.num*size(X,4)));
%         X_aug(:,:,:,idx) = rotate_vox(X(:,:,:,i), ...
%             aug.noise*randn(1), aug.noise*randn(1),deg);
%     end
% end
% y_aug = repelem(y,aug.num,1);
% Split into train and test
% X_train = X_aug(:,:,:,repelem(mdb.set == 0,aug.num,1));
% y_train = y_aug(repelem(mdb.set == 0,aug.num,1));
% X_test = X_aug(:,:,:,repelem(mdb.set == 1,aug.num,1));
% y_test = y_aug(repelem(mdb.set == 1,aug.num,1));

split = 0.5;
Ntr = floor(size(X,4)*split);

X_train = X(:,:,:,1:Ntr);
Y_train = Y(:,:,:,1:Ntr);
X_test = X(:,:,:,Ntr+1:end);
Y_test = Y(:,:,:,Ntr+1:end);

% Transpose so N x C x H x W x D (to add a C dim)
X_train = permute(X_train, [4 5 1 2 3]);
Y_train = permute(Y_train, [4 5 1 2 3]);
X_test = permute(X_test, [4 5 1 2 3]);
Y_test = permute(Y_test, [4 5 1 2 3]);

% Transpose for caffe D x H x W x C x N
X_train = permute(X_train, [5 4 3 2 1]);
Y_train = permute(Y_train, [5 4 3 2 1]);
X_test = permute(X_test, [5 4 3 2 1]);
Y_test = permute(Y_test, [5 4 3 2 1]);

% % Subtract mean
% mean_image = mean(X_train, 5); % use training data for mean
% X_train = X_train - repmat(mean_image,[1,1,1,1,size(X_train,5)]);
% X_test = X_test - repmat(mean_image,[1,1,1,1,size(X_test,5)]);
X_train = X_train - mean(X_train(:));
X_test = X_test - mean(X_train(:));

% Print out sizes
display('Size of Training set: ');
display(size(X_train));
display('Size of Test set: ');
display(size(X_test));

dataset = 'scenes';

fname = ['../data/hdf5/train_' dataset '.h5'];
delete(fname);
h5create(fname, '/data', size(X_train), 'Datatype', 'single')
h5write(fname, '/data', single(X_train))
h5create(fname, '/label', size(Y_train), 'Datatype', 'single')
h5write(fname, '/label', single(Y_train))

fname = ['../data/hdf5/test_' dataset '.h5'];
delete(fname);
h5create(fname, '/data', size(X_test), 'Datatype', 'single')
h5write(fname, '/data', single(X_test))
h5create(fname, '/label', size(Y_test), 'Datatype', 'single')
h5write(fname, '/label', single(Y_test))



