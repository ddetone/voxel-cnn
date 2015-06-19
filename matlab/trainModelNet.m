CAFFE = '../caffe';
addpath([CAFFE '/matlab/caffe']);
caffe.reset_all()
clear all

caffe.set_mode_gpu();
caffe.set_device(0);

SOLVER_FILE = '../proto/two_layer_conv/solver.prototxt';
solver = caffe.Solver(SOLVER_FILE);
solver.solve();
