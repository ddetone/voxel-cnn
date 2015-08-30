
path = '../data/ModelNet40';
rawDataDir = dir(path);
cls = {'tv_stand', 'chair', 'sofa', 'table' };

medians = zeros(size(cls,2),3);
for i=1:size(cls,2)
  d = dir(fullfile(path,cls{i},'train','*.off'));
  avgs = zeros(0,3);
  for j=1:size(d,1)
    model_path = fullfile(path,cls{i},'train',d(j).name);
    [vertices, faces] = read_off(model_path);
    dims = max(vertices,[],2) - min(vertices,[],2);
    avgs(end+1,:) = dims';
  end
  medians(i,:) = median(avgs);
  
  
end