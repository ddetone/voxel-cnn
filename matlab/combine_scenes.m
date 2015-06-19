clear all
for i=1:4
   load(['0' num2str(i) '_data.mat']);
   X(:,:,:,i) = vox;
   Y(:,:,:,i) = y;
end

save('scenes.mat','X','Y');