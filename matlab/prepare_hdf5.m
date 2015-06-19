dataset = 'mdb10_dim20';
load(['../data/' dataset '.mat'])

X = mdb.data;
y = mdb.class;

% Data augmentation via random rotations
aug.num = 12;
aug.deg = 30;
aug.noise = 3;
X_aug = zeros(size(repelem(X,1,1,1,aug.num)));
for i=1:size(X,4)
    for j=1:aug.num
        deg = floor(aug.deg*j + aug.noise*randn(1));
        idx = (i-1)*aug.num + j;
        disp(sprintf('idx is: %d \t of %d', idx, ...
            aug.num*size(X,4)));
        X_aug(:,:,:,idx) = rotate_vox(X(:,:,:,i), ...
            aug.noise*randn(1), aug.noise*randn(1),deg);
    end
end
y_aug = repelem(y,aug.num,1);

% Split into train and test
X_train = X_aug(:,:,:,repelem(mdb.set == 0,aug.num,1));
y_train = y_aug(repelem(mdb.set == 0,aug.num,1));
X_test = X_aug(:,:,:,repelem(mdb.set == 1,aug.num,1));
y_test = y_aug(repelem(mdb.set == 1,aug.num,1));

% Transpose so N x C x H x W x D
X_train = permute(X_train, [4 5 1 2 3]);
X_test = permute(X_test, [4 5 1 2 3]);

% Transpose for caffe D x H x W x C x N
X_train = permute(X_train, [5 4 3 2 1]);
y_train = permute(y_train, [2 1]);
X_test = permute(X_test, [5 4 3 2 1]);
y_test = permute(y_test, [2 1]);

% % Subtract mean
% mean_image = mean(X_train, 5); % use training data for mean
% X_train = X_train - repmat(mean_image,[1,1,1,1,size(X_train,5)]);
% X_test = X_test - repmat(mean_image,[1,1,1,1,size(X_test,5)]);
X_train = X_train - mean(X_train(:));
X_test = X_test - mean(X_train(:));

% % Create mini train set to overfit to
% size_mini = 50;
% N_train = size(X_train,5);
% idx_mini = int32(1:ceil(N_train)/size_mini:N_train);
% X_train_mini = X_train(:,:,:,:,idx_mini);
% y_train_mini = y_train(idx_mini);

% Print out sizes
display('Size of Training set: ');
display(size(X_train));
display('Size of Test set: ');
display(size(X_test));

fname = ['../data/hdf5/train_' dataset '.h5'];
delete(fname);
h5create(fname, '/data', size(X_train), 'Datatype', 'single')
h5write(fname, '/data', single(X_train))
h5create(fname, '/label', size(y_train), 'Datatype', 'single')
h5write(fname, '/label', single(y_train))

fname = ['../data/hdf5/test_' dataset '.h5'];
delete(fname);
h5create(fname, '/data', size(X_test), 'Datatype', 'single')
h5write(fname, '/data', single(X_test))
h5create(fname, '/label', size(y_test), 'Datatype', 'single')
h5write(fname, '/label', single(y_test))

% display('Size of train mini set: ');
% display(size(X_train_mini));
% fname = ['../data/hdf5/train_mini_' dataset '.h5'];
% delete(fname);
% h5create(fname, '/data', size(X_train_mini), 'Datatype', 'single')
% h5write(fname, '/data', single(X_train_mini))
% h5create(fname, '/label', size(y_train_mini), 'Datatype', 'single')
% h5write(fname, '/label', single(y_train_mini))



