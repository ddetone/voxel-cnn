% function net_surgery()

addpath('/home/ddetone/code/caffe/matlab/caffe')

CAFFE = '/home/ddetone/code/caffe';
fc_param_file = ...
    [CAFFE '/models/bvlc_reference_caffenet/deploy.prototxt'];
conv_param_file = ...
    [CAFFE '/examples/net_surgery/bvlc_caffenet_full_conv.prototxt'];
model_file = ...
    [CAFFE '/models/bvlc_reference_caffenet/bvlc_reference_caffenet.caffemodel'];

net = CaffeNet.instance(fc_param_file, model_file);
p_fc.fc6 = net.get_layer_weights('fc6');
p_fc.fc7 = net.get_layer_weights('fc7');
p_fc.fc8 = net.get_layer_weights('fc8');
print_params(p_fc);

net = CaffeNet.instance(conv_param_file, model_file);
p_conv.fc6_conv = net.get_layer_weights('fc6-conv');
p_conv.fc7_conv = net.get_layer_weights('fc7-conv');
p_conv.fc8_conv = net.get_layer_weights('fc8-conv');
print_params(p_conv);


p_conv.fc6_conv{1}(:) = p_fc.fc6{1}(:);
p_conv.fc6_conv{2}(:) = p_fc.fc6{2}(:);
net.set_layer_weights('fc6-conv', p_conv.fc6_conv);
net.set_layer_weights('fc6-conv', p_conv.fc6_conv);
p_conv.fc7_conv{1}(:) = p_fc.fc7{1}(:);
p_conv.fc7_conv{2}(:) = p_fc.fc7{2}(:);
net.set_layer_weights('fc7-conv', p_conv.fc7_conv);
net.set_layer_weights('fc7-conv', p_conv.fc7_conv);
p_conv.fc8_conv{1}(:) = p_fc.fc8{1}(:);
p_conv.fc8_conv{2}(:) = p_fc.fc8{2}(:);
net.set_layer_weights('fc8-conv', p_conv.fc8_conv);
net.set_layer_weights('fc8-conv', p_conv.fc8_conv);


if nargin < 1 || isempty(im)
  % For demo purposes we will use the peppers image
  im = imread('pepper_small.jpg');
end

% prepare oversampled input
% input_data is Height x Width x Channel x Num
tic;
input_data = {prepare_image(im)};
toc;

% do forward pass to get scores
% scores are now Width x Height x Channels x Num
tic;
scores = net.forward(input_data);
toc;

scores = scores{1};
size(scores);

[~,I] = max(permute(scores, [3 1 2]));

% end

