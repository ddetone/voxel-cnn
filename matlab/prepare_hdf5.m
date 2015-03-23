load('../data/mdb.mat')

% Split into train and test
X_train = mdb.data(:,:,:,mdb.set == 0);
y_train = mdb.class(mdb.set == 0);
X_test = mdb.data(:,:,:,mdb.set == 1);
y_test = mdb.class(mdb.set == 1);

% Transpose so N x C x H x W x D
X_train = permute(X_train, [4 5 1 2 3]);
X_test = permute(X_test, [4 5 1 2 3]);

% Transpose for caffe D x H x W x C x N
X_train = permute(X_train, [5 4 3 2 1]);
y_train = permute(y_train, [2 1]);
X_test = permute(X_test, [5 4 3 2 1]);
y_test = permute(y_test, [2 1]);

% Subtract mean
mean_image = mean(X_train, 5); % use training data for mean
X_train = X_train - repmat(mean_image,[1,1,1,1,size(X_train,5)]);
X_test = X_test - repmat(mean_image,[1,1,1,1,size(X_test,5)]);

fname = '../data/hdf5/train.h5';
delete(fname);
h5create(fname, '/data', size(X_train), 'Datatype', 'single')
h5write(fname, '/data', single(X_train))
h5create(fname, '/label', size(y_train), 'Datatype', 'single')
h5write(fname, '/label', single(y_train))

fname = '../data/hdf5/test.h5';
delete(fname);
h5create(fname, '/data', size(X_test), 'Datatype', 'single')
h5write(fname, '/data', single(X_test))
h5create(fname, '/label', size(y_test), 'Datatype', 'single')
h5write(fname, '/label', single(y_test))



