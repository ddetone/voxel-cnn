CAFFE_PATH = '/home/ddetone/code/caffe/build/tools/caffe';
SOLVER_FILE = '/home/ddetone/code/voxel-convnet/caffe-scripts/solver.prototxt';

SOLVE = [CAFFE_PATH ' train -solver ' SOLVER_FILE];
system(SOLVE);