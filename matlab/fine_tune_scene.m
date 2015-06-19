CAFFE = '../caffe';
addpath([CAFFE '/matlab/caffe']);

NET_SURG = '../proto/net_surgery/';
model_file = [NET_SURG 'fully_conv.prototxt'];
weights_file = [NET_SURG 'snapshot/fully_conv_86acc.caffemodel'];
net = CaffeNet3D.instance(model_file, weights_file);

