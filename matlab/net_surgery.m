caffe.reset_all()
caffe.set_mode_gpu();
caffe.set_device(0);

NET = 'two_layer_conv';
SEG_TYPE = 'fc4';
WEIGHTS = 'dim20_iter_5000.caffemodel';

rec_weights = ['../proto/' NET '/rec/snapshot/' WEIGHTS];
rec_file = ['../proto/' NET '/rec/train_test.prototxt'];
rec_net = caffe.Net(rec_file, rec_weights, 'test');
seg_file = ['../proto/' NET '/seg-' SEG_TYPE '/net_surgery.prototxt'];
seg_net = caffe.Net(seg_file, rec_weights, 'test');

% transplant fully-connected layer weights in fully convolutional
fc.weights = rec_net.params('fc3',1).get_data();
fc.bias = rec_net.params('fc3',2).get_data();
fc_conv.weights = seg_net.params('fc3-conv',1).get_data();
fc_conv.bias = seg_net.params('fc3-conv',2).get_data();
fc_conv.weights(:) = fc.weights(:);
fc_conv.bias(:) = fc.bias(:);
seg_net.params('fc3-conv',1).set_data(fc_conv.weights);

% transplant bilinear filters into upscore layers
for l = 1:size(seg_net.layer_names,1)
    layer = seg_net.layer_names{l};
    if strfind(layer,'upsample')
        upsample_layer = seg_net.params(layer,1).get_data();
        F = size(upsample_layer, 1);
        Cin = size(upsample_layer, 4);
        Cout = size(upsample_layer, 5);
        bifilt = upsample_filt(F);
        bifilt = single(bifilt);
        if Cin ~= Cout
            disp('error');
        else
            for i=1:Cin
               p_fc.upsample(:,:,:,i,i) = bifilt; 
            end
        end
        seg_net.params(layer, 1).set_data(upsample_layer);
    end
end

% Save the net
out_weights_file = ['../proto/' NET '/seg-' SEG_TYPE '/snapshot/net_surgery.caffemodel'];
seg_net.save(out_weights_file);
