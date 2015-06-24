dim = 20;
pad = 0;
mdb.data = false(dim+2*pad,dim+2*pad,dim+2*pad,0);
mdb.set = zeros(0,1);
mdb.class = zeros(0,1);
clip_cls = 25;
train_count = 0;

visualize = false;
augment_data = false;

% Data augmentation parameters
aug.num = 12;
aug.rdeg = 30;
aug.rnoise_xy = 3;
aug.rnoise_z = 3;
aug.smax = 1.50;       %scale randomly between 50-200% [unif]
aug.smin = 0.50;
aug.tmax = 0.10*dim; %translate randomly btwn (-tmax*dim)-(tmax*dim) [unif]

mdb.meta.set_names = containers.Map({'train', 'test'}, {0, 1});
mdb.meta.class_names = containers.Map;

mdlnetdir = '../data/ModelNet10';
rawDataDir = dir(mdlnetdir);
count = 0;
for class = rawDataDir'
    if (~isdir(fullfile(mdlnetdir,class.name)) || ...
            strcmp(class.name,'.') || strcmp(class.name,'..')), continue; end

    if ~isKey(mdb.meta.class_names, class.name)
        mdb.meta.class_names(class.name) = length(mdb.meta.class_names);
    end
    testTrainDir = dir(fullfile(mdlnetdir,class.name));
    for set = testTrainDir'
        setDir = dir(fullfile(mdlnetdir,class.name,set.name));
        if (strcmp(set.name,'.') || strcmp(set.name,'..')), continue; end
        train_count = 0;
        disp(['count:' num2str(count) ' ' set.name ',' class.name]);
        for model = setDir'
            if (strcmp(model.name,'.') || strcmp(model.name,'..')), continue; end
            
            % limit examples per class to prevent class imbalances
            if strcmp(set.name,'train') 
                if (train_count >= clip_cls), continue;
                else train_count = train_count + 1; end
            end
            
            MODELPATH_OFF = fullfile(mdlnetdir,class.name,set.name,model.name);
            [vertices, faces] = read_off(MODELPATH_OFF);
            FV.faces = faces';
            FV.vertices = vertices';
            disp(max(vertices(:)) - min(vertices(:)));
            volume = polygon2voxel(FV,[dim dim dim],'auto','TRUE','TRUE');
            volume = padarray(volume, [pad pad pad]);
            mdb.data(:,:,:,end+1) = volume;
            mdb.set(end+1,1) = mdb.meta.set_names(set.name);
            mdb.class(end+1,1) = mdb.meta.class_names(class.name);
            count = count + 1;
            
            if visualize
                figure(1)
                show_vox(volume);
                pause()
            end
             
            if strcmp(set.name,'train') && augment_data
                for j = 1:aug.num
                    verts_aug = vertices;
                    verts_aug = verts_aug - min(verts_aug(:));
                    scaling = min((dim-1) ./ (max(verts_aug(:))));
                    verts_aug = verts_aug * scaling+1;
                    rot.X = aug.rnoise_xy*randn(1);
                    rot.Y = aug.rnoise_xy*randn(1);
                    deg = floor(aug.rdeg*j + aug.rnoise_z*randn(1));
                    rot.Z = deg;
                    tr.X = 2*aug.tmax*(rand(1,1)-0.5);
                    tr.Y = 2*aug.tmax*(rand(1,1)-0.5);
                    tr.Z = 2*aug.tmax*(rand(1,1)-0.5);
                    sc = (aug.smax-aug.smin)*rand(1,1)+aug.smin;

                    verts_aug = verts_aug - dim/2; %center
                    verts_aug = transform_verts(verts_aug,rot,tr,sc);
                    verts_aug = verts_aug + dim/2; %uncenter

                    FV_aug.faces = faces';
                    FV_aug.vertices = verts_aug';

                    volume_aug = polygon2voxel(FV_aug,[dim dim dim],...
                        'none','TRUE','TRUE');
                    volume_aug = padarray(volume_aug, [pad pad pad]);

                    mdb.data(:,:,:,end+1) = volume_aug;
                    mdb.set(end+1,1) = mdb.meta.set_names(set.name);
                    mdb.class(end+1,1) = mdb.meta.class_names(class.name);
                    count = count + 1;
                    
                    if visualize
                        figure(1)
                        show_vox(volume);
                        figure(2)
                        show_vox(volume_aug);
                        pause()
                    end
                end
            end
        end    
    end
end

disp(['num train is: ' num2str(size(mdb.class(mdb.set==0),1))]);
disp(['num test is: ' num2str(size(mdb.class(mdb.set==1),1))]);
ncls = max(mdb.class(:))+1;
for c=0:ncls-1
    ntr = size(mdb.class(mdb.class==c & mdb.set==0),1);
    nte = size(mdb.class(mdb.class==c & mdb.set==1),1);
    disp([' class ' num2str(c) ' is: ' get_class_string(c,false) ...
          ' | num train is: ' num2str(ntr) ' num test is: ' num2str(nte)]);
end

dataset = 'mdb10_dim20_100tr';
save(['../data/' dataset '.mat'],'mdb');
