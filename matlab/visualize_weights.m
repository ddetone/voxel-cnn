caffe.reset_all()
caffe.set_mode_gpu();

RECOG_FOLDER = '../proto/two_layer_conv/rec/';
model_file = [RECOG_FOLDER 'deploy.prototxt'];
weights_file = [RECOG_FOLDER 'snapshot/dim20_iter_5000.caffemodel'];
net = caffe.Net(model_file, weights_file, 'test');

conv = net.params('conv1',1).get_data;
N = size(conv,5);

figure(1)
clf
for i = 1:N
    subplot(6,6,i)
    sample = squeeze(conv(:,:,:,1,i));
    h = vol3d('cdata',sample,'texture','3D');
    az = -45;
    el = -45;
    view(az, el);
    axis([0 3 0 3 0 3])
    axis off;
    colormap gray
end
figure(2)
clf
for i = 1:N
    subplot(6,6,i)
    sample = squeeze(conv(:,:,:,1,i));
    show_sample(sample,0.01);
end