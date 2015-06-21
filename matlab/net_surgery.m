caffe.reset_all()
clear all

caffe.set_mode_gpu();
caffe.set_device(0);

recog_fold = '../proto/two_layer_conv/';
recog_weights = [recog_fold 'snapshot/dim20_aug_iter_3000.caffemodel'];
recog_file = [recog_fold 'train_test.prototxt'];
s_net = caffe.Net(recog_file, recog_weights, 'test');

scene_fold = '../proto/two_layer_conv_scene/';
scene_file = [scene_fold 'train_test.prototxt'];
fc_net = caffe.Net(scene_file, recog_weights, 'test');

p_s.fc3.weights = s_net.params('fc3',1).get_data();
p_s.fc3.bias = s_net.params('fc3',2).get_data();
p_s.fc4.weights = s_net.params('fc4',1).get_data();
p_s.fc4.bias = s_net.params('fc4',2).get_data();

p_fc.fc3_conv.weights = fc_net.params('fc3-conv',1).get_data();
p_fc.fc3_conv.bias = fc_net.params('fc3-conv',2).get_data();
p_fc.fc4_conv.weights = fc_net.params('fc4-conv',1).get_data();
p_fc.fc4_conv.bias = fc_net.params('fc4-conv',2).get_data();

% transplant fully-connected layer weights in fully convolutional
p_fc.fc3_conv.weights(:) = p_s.fc3.weights(:);
p_fc.fc3_conv.bias(:) = p_s.fc3.bias(:);
fc_net.params('fc3-conv',1).set_data(p_fc.fc3_conv.weights);
p_fc.fc4_conv.weights(:) = p_s.fc4.weights(:);
p_fc.fc4_conv.bias(:) = p_s.fc4.bias(:);
fc_net.params('fc4-conv',1).set_data(p_fc.fc4_conv.weights);

% transplant into upscore layer
p_fc.upscore = fc_net.params('upscore',1).get_data();
F = size(p_fc.upscore, 1);
Cin = size(p_fc.upscore, 4);
Cout = size(p_fc.upscore, 5);
bifilt = upsample_filt(F);
bifilt = single(bifilt);
if Cin ~= Cout
    disp('error');
else
    for i=1:Cin
       p_fc.upscore(:,:,:,i,i) = bifilt; 
    end
end
fc_net.params('upscore', 1).set_data(p_fc.upscore);

% Save the net
out_weights_file = [scene_fold 'snapshot/fully_conv_upsamp.caffemodel'];
fc_net.save(out_weights_file);
