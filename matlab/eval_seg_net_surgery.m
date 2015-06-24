caffe.reset_all()
CAFFE = '../caffe';
addpath([CAFFE '/matlab/caffe']);
caffe.set_mode_gpu();
caffe.set_device(0);

close all
NET = 'two_layer_conv';
WEIGHTS = 'net_surgery.caffemodel';
model_file = ['../proto/' NET '/seg/net_surgery_deploy.prototxt'];
weights_file = ['../proto/' NET '/seg/snapshot/' WEIGHTS];
net = caffe.Net(model_file, weights_file, 'test');

% % load('02_data.mat');
% load('../data/mdb10_dim20.mat');
% idx = 1000;
% vox = single(mdb.data(:,:,:,idx));
% y = mdb.class(idx);
% show_vox(vox);
% input_data = permute(vox, [3 2 1]); %permute for caffe

load(['scene_data/' '02_data.mat']);
input_data = permute(vox, [3 2 1]); %permute for caffe

tic
scores = net.forward({input_data});
toc
scores = scores{1};
scores = permute(scores, [3 2 1 4]); %unpermute for matlab


[~,vox_guesses] = max(scores,[],4);
vox_guesses(vox==0) = 0;

clf
% figure(1)
% show_vox(vox)
figure(2)
show_vox(vox_guesses,10,false)
% figure(3)
% show_vox(y,10,false)

% subplot(1,3,3)
% add_class_labels(false)

% scores = scores - min(scores(:));
% scores = scores / max(scores(:));
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