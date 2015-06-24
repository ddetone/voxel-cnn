% caffe.reset_all()
% caffe.set_mode_gpu();
% RECOG_FOLDER = '../proto/two_layer_conv/rec/';
% model_file = [RECOG_FOLDER 'visualize.prototxt'];
% weights_file = [RECOG_FOLDER 'snapshot/dim20_iter_5000.caffemodel'];
% net = caffe.Net(model_file, weights_file, 'test');
% 
% dataset = 'mdb10_dim20_100tr';
% load(['../data/' dataset '.mat'],'mdb');
% X_train = mdb.data(:,:,:,mdb.set == 0);
% X_train = permute(X_train,[3 2 1 5 4]);
% 
% 
% batch_size = 50;
% N = size(X_train,5);
% num_batches = floor(N/batch_size);
% 
% activations = [];
% layer = 'conv1';
% for i = 1:num_batches
%     idx = (i-1)*batch_size+1:(i-1)*batch_size + batch_size;
%     input_data = X_train(:,:,:,:,idx);
%     net.forward({single(input_data)});
%     out = net.blobs(layer).get_data;
%     if isempty(activations)
%         activations = out;
%     else
%         activations(:,:,:,:,idx) = out;
%     end
% end

% CH = size(activations,4);
% locs = zeros(4,CH);
% for c=1:CH
%     M = activations(:,:,:,c,:);
%     [C,I] = max(M(:));
%     [I1,I2,I3,I4] = ind2sub(size(M),I);
%     locs(:,c) = [I1; I2; I3; I4];
% end

% CH = size(activations,4);
% top = 10;
% locs = zeros(4,top,CH);
% for c=1:CH
%     M = activations(:,:,:,c,:);
%     [C,I] = sort(M(:),'descend');
%     [I1,I2,I3,I4] = ind2sub(size(M),I(1:top));
%     locs(:,:,c) = [I1'; I2'; I3'; I4'];
% end

% X_train = padarray(X_train, [1 1 1 0 0]);

for c=1:CH
    sample = zeros(3,3,3);
    for t=1:top
        i = [locs(1,t,c) locs(2,t,c) locs(3,t,c)];
        z(1,:) = i-1;
        z(2,:) = i+1;
        z = z + 1;
        sample =  sample + double(X_train(z(1,1):z(2,1), z(1,2):z(2,2), ...
            z(1,3):z(2,3), 1, locs(4,c)));
    end
    sample = sample / top;
    figure(4)
    subplot(6,6,c)
    show_sample(single(sample),0.01);
    
    figure(5)
    h = vol3d('cdata',sample,'texture','3D');
    az = -45;
    el = -45;
    view(az, el);
    axis([0 3 0 3 0 3])
    axis off;
    colormap gray
    
end


