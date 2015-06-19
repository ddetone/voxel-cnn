caffe.reset_all()
CAFFE = '../caffe';
addpath([CAFFE '/matlab/caffe']);
caffe.set_mode_gpu();
caffe.set_device(0);

NET_SURG = '../proto/two_layer_conv/';
model_file = [NET_SURG 'fully_conv_eval.prototxt'];
weights_file = [NET_SURG 'snapshot/scene_finetune/_iter_1000.caffemodel'];
net = caffe.Net(model_file, weights_file, 'test');

load('03_data.mat','vox');
input_data = vox - mean(vox(:));
input_data = {single(input_data)};
tic
net.forward(input_data);
toc

% tic
% net.forward_prefilled();
% toc
% scores = net.blobs('upscore').get_data();

% scores = permute(scores,[3 2 1 4 5]);
% scores = scores(:,:,:,:,1);
scores = scores - min(scores(:));
scores = scores / max(scores(:));
load('03_data.mat','y');

in = net.blobs('data').get_data();
show_vox(in + mean(in(:)));

% scores = scores * 64;
% subplot(2,1,1)
% show_vox(vox);
% hold off
% subplot(2,1,2)
% colormap bone;
% for idx=1:10
%     I = squeeze(scores(:,:,:,idx));
%     guess = get_class_string(idx-1);
%     disp(guess);
%     image(I(:,:));
% %     vol3d('Cdata', I, 'xdata', [0 size(I,1)], 'ydata', ...
% %         [0 size(I,2)], 'zdata', [0 size(I,3)]);
% %     axis([0 size(scores,1) 0 size(scores,2) 0 size(scores,3)]);
% %     alphamap default;
% %     alphamap('decrease')
% 
% end

[~,vox_guesses] = max(scores,[],4);
vox_guesses(permute(y,[3 2 1])==0) = -1;
show_vox(vox_guesses,10)
colorbar
for i=1:10
    uicontrol('Style', 'text',...
       'String', get_class_string(i-1,true),... 
       'Units','normalized',...
       'Position', [0.91 (i/10) 0.1 0.1]); 
end