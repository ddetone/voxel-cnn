caffe.reset_all()
caffe.set_mode_gpu();

RECOG_FOLDER = '../proto/two_layer_conv/rec/';
model_file = [RECOG_FOLDER 'deploy.prototxt'];
weights_file = [RECOG_FOLDER 'snapshot/dim20_iter_5000.caffemodel'];
net = caffe.Net(model_file, weights_file, 'test');
ncls = 10;

dataset = 'mdb10_dim20_100tr';
load([dataset '_test.mat'],'X_test','y_test');
N = size(X_test,5);
batch_size = 50;
iters = floor(N/batch_size);
scores = zeros(N,ncls);

tic
for i=1:iters
    idx = (i-1)*batch_size+1:(i-1)*batch_size + batch_size;
    input_data = X_test(:,:,:,:,idx);
    net.forward({single(input_data)});
    scores(idx,:) = net.blobs('fc4').get_data()';
end
toc

[~,preds] = max(scores,[],2);
preds = preds - 1;

num_ex = zeros(ncls,1);
acc_ex = zeros(ncls,1);
for c=0:9
    num_ex(c+1) = sum(y_test==c);
    acc_ex(c+1) = sum(preds(y_test==c) == c) / num_ex(c+1);
    disp([' acc is: ' num2str(acc_ex(c+1),'%.3f') ...
          ' class ' num2str(c) ' is: ' get_class_string(c,false)]);
end
acc = sum(acc_ex) / ncls;
disp(['final acc is: ' num2str(acc,'%.3f')]);
C = confusionmat(y_test,preds);
disp(C);

% % Print confusion matrix heatmap
% C_ratio = C ./ repmat(sum(C),[size(C,1) 1]);
% disp(C_ratio);
% colormap parula
% imagesc(C_ratio);

% % % Print each prediction
% for i=1:N
%    disp(['iter: ' num2str(i) ...
%        ' |  pred is: ' get_class_string(preds(i),false) ...
%        ' |  actual is ' get_class_string(y_test(i),false)]);
% end


