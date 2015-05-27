% function net_surgery()

addpath('/home/ddetone/code/caffe/matlab/caffe')

CAFFE = '/home/ddetone/code/caffe';
NET_SURG = '/home/ddetone/code/voxel-convnet/caffe-scripts/net_surgery/';

fc_model_file = [NET_SURG 'standard.prototxt'];
conv_model_file = [NET_SURG 'fully_conv.prototxt'];
weights_file = [NET_SURG '_iter_5000.caffemodel'];
% fc_model_file = [CAFFE '/models/bvlc_reference_caffenet/deploy.prototxt'];
% conv_model_file = [CAFFE '/examples/net_surgery/bvlc_caffenet_full_conv.prototxt'];
% weights_file = [CAFFE '/models/bvlc_reference_caffenet/bvlc_reference_caffenet.caffemodel'];

net = CaffeNet3D.instance(fc_model_file, weights_file);
p_fc.ip1 = net.get_layer_weights('ip1');
p_fc.ip2 = net.get_layer_weights('ip2');
print_params(p_fc);

net = CaffeNet3D.instance(conv_model_file, weights_file);
p_conv.ip1_conv = net.get_layer_weights('ip1-conv');
p_conv.ip2_conv = net.get_layer_weights('ip2-conv');
print_params(p_conv);

p_conv.ip1_conv{1}(:) = p_fc.ip1{1}(:);
p_conv.ip1_conv{2}(:) = p_fc.ip1{2}(:);
net.set_layer_weights('ip1-conv', p_conv.ip1_conv);
p_conv.ip2_conv{1}(:) = p_fc.ip2{1}(:);
p_conv.ip2_conv{2}(:) = p_fc.ip2{2}(:);
net.set_layer_weights('ip2-conv', p_conv.ip2_conv);

load('/home/ddetone/code/voxel-convnet/data/mdb10_dim16_BO.mat');
N = size(mdb.data,4)
pred = zeros(N,1);
for i=1:N
    
    idx = i;
    mdl = mdb.data(:,:,:,idx);
%     im = imread('hot-dog.jpg');
    
%     figure(1) 
%     subplot(1,2,1)
%     [X,Y,Z]=ind2sub(size(mdl),find(mdl(:)));
%     plot3(X,Y,Z,'.');
%     axis equal;
%     xlim([0 dim])
%     ylim([0 dim])
%     zlim([0 dim])
%     xlabel('x');
%     ylabel('y');
%     zlabel('z');
    
    load('dataset_mean.mat');
%     Transpose so N x C x H x W x D
    mdl = permute(mdl, [4 5 1 2 3]);
    mean_image = permute(mean_image, [4 5 1 2 3]);
%     Transpose for caffe D x H x W x C x N
    mdl = permute(mdl, [5 4 3 2 1]);
    mean_image = permute(mean_image, [5 4 3 2 1]);
    mdl = mdl - mean_image;

    input_data = {single(mdl)};
    scores = net.forward(input_data);

    scores = scores{1};
    [~,I] = max(permute(scores, [4 1 2 3]));
    pred(i) = I-1;
    guess = get_class_string(I-1);
    gt = get_class_string(mdb.class(idx));
    fprintf('pred is: %d (%s),\t actual is: %d (%s) \n',I-1,guess,mdb.class(idx),gt); 
%     fprintf('idx %d\n', i);
end
% end

