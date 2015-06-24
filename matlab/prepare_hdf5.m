dataset = 'mdb10_dim20_100tr';
load(['../data/' dataset '.mat'],'mdb');

% Split into train and test
X_train = mdb.data(:,:,:,mdb.set == 0);
y_train = mdb.class(mdb.set == 0);
X_test = mdb.data(:,:,:,mdb.set == 1);
y_test = mdb.class(mdb.set == 1);

% Transpose for caffe D x W x H x C x N
X_train = permute(X_train, [3 2 1 5 4]);
y_train = permute(y_train, [2 1]);
X_test = permute(X_test, [3 2 1 5 4]);
y_test = permute(y_test, [2 1]);

save([dataset '_test.mat'],'X_test','y_test');

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



