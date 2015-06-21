dataset = 'mdb10_dim20_100tr_aug';
load(['../data/' dataset '.mat'])

N = size(X,4);
dim = size(X,1);
ncls = 10;

num_ex = zeros(ncls);
for c=0:ncls-1
    num_ex(c+1) = sum(y==c);
    disp([' class ' num2str(c) ' is: ' get_class_string(c,false) ...
          ' count is: ' num2str(num_ex(c+1))]);
end

for i=1:N
    off = 0;
    vox = X(:,:,:,i+off);
    show_vox(vox);
    axis([0 dim 0 dim 0 dim])
    pause(0.1);
end
