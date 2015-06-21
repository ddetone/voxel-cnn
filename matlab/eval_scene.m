caffe.reset_all()
CAFFE = '../caffe';
addpath([CAFFE '/matlab/caffe']);

NET_SURG = '../proto/two_layer_conv_scene/';
model_file = [NET_SURG 'deploy.prototxt'];
weights_file = [NET_SURG 'snapshot/fully_conv_upsamp.caffemodel'];
net = caffe.Net(model_file, weights_file, 'test');

load('02_data.mat');
vox = permute(vox, [3 2 1 5 4]);

tic
scores = net.forward({vox});
toc
scores = scores{1};
scores = scores - min(scores(:));
scores = scores / max(scores(:));

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
vox_guesses(vox==0) = -1;
show_vox(vox_guesses,10)
colorbar
for i=1:10
    uicontrol('Style', 'text', ...
       'String', get_class_string(i-1,false),... 
       'Units','normalized',...
       'Position', [0.91 (i/10) 0.1 0.1]); 
end
