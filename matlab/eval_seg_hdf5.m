caffe.reset_all()
CAFFE = '../caffe';
addpath([CAFFE '/matlab/caffe']);
caffe.set_mode_gpu();
caffe.set_device(0);

NET = 'two_layer_conv';
WEIGHTS = 'finetune_iter_1000.caffemodel';
model_file = ['../proto/' NET '/seg/finetune_deploy_hdf5.prototxt'];
weights_file = ['../proto/' NET '/seg/snapshot/' WEIGHTS];
net = caffe.Net(model_file, weights_file, 'test');

% load('03_data.mat','vox');
% % input_data = vox - mean(vox(:));
% input_data = {single(input_data)};
% tic
% net.forward(input_data);
% toc

tic
net.forward_prefilled();
toc

labels = net.blobs('label').get_data();
lbl = labels(:,:,:,1);
lbl = permute(lbl, [3 2 1]);
show_vox(lbl,10,true);

% scores = net.blobs('data').get_data();

% 
% % scores = permute(scores,[3 2 1 4 5]);
% % scores = scores(:,:,:,:,1);
% scores = scores - min(scores(:));
% scores = scores / max(scores(:));
% load('03_data.mat','y');
% 
% in = net.blobs('data').get_data();
% show_vox(in + mean(in(:)));
% 
% [~,vox_guesses] = max(scores,[],4);
% vox_guesses(permute(y,[3 2 1])==0) = -1;
% show_vox(vox_guesses,10)
% colorbar
% for i=1:10
%     uicontrol('Style', 'text',...
%        'String', get_class_string(i-1,true),... 
%        'Units','normalized',...
%        'Position', [0.91 (i/10) 0.1 0.1]); 
% end
