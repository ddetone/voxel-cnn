caffe.reset_all()
CAFFE = '../caffe';
addpath([CAFFE '/matlab/caffe']);
caffe.set_mode_gpu();
caffe.set_device(0);

NET = 'two_layer_conv';
WEIGHTS = 'finetune_iter_10000.caffemodel';
model_file = ['../proto/' NET '/seg/finetune_deploy.prototxt'];
weights_file = ['../proto/' NET '/seg/snapshot/' WEIGHTS];
net = caffe.Net(model_file, weights_file, 'test');

load(['scene_data/' '02_data.mat']);
rot.X = 0; rot.Y = 0; rot.Z = 45;
tr.X = 0; tr.Y = 0; tr.Z = 0;
sc = 0.8;
vox = rotate_vox(vox,rot,tr,sc,true);
input_data = permute(vox, [4 5 1 2 3]);
input_data = repmat(input_data,[2 1 1 1 1]);
input_data = permute(input_data, [5 4 3 2 1]);
% input_data = permute(vox, [3 2 1]); %permute for caffe

tic
scores = net.forward({input_data});
toc
scores = scores{1};
scores = scores(:,:,:,:,1);

[~,vox_guesses] = max(scores,[],4);
vox_guesses = permute(vox_guesses, [3 2 1]); %unpermute for matlab


vox_guesses(vox==0) = 0;

% vox_guesses(y==10) = 0;
% y(y==10) = 0;

% close all
clf
% figure(3)
% show_vox(vox)
figure(1)
show_vox(y,10,true)
figure(2)
show_vox(vox_guesses,10,true)


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