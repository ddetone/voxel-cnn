scene = 'scenes_mini.mat';
load(['scene_data/' scene]);

Y = Y - 1;
% Y(Y==9) = -1;

N = size(X,4);
tr_idx = 1:2:N;
te_idx = 2:2:N;

X_train = X(:,:,:,tr_idx);
Y_train = Y(:,:,:,tr_idx);
X_test = X(:,:,:,te_idx);
Y_test = Y(:,:,:,te_idx);

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



