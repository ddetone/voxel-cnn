dim = 20;
pad = 0;
mdb.data = false(dim+2*pad,dim+2*pad,dim+2*pad,0);
mdb.set = zeros(0,1);
mdb.class = zeros(0,1);
clip_cls = 100;
train_count = 0;

mdb.meta.set_names = containers.Map({'train', 'test'}, {0, 1});
mdb.meta.class_names = containers.Map;

mdlnetdir = '../data/ModelNet10';
rawDataDir = dir(mdlnetdir);
iter = 0;
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
        disp(['iteration:' num2str(iter) ' ' set.name ',' class.name]);
        for model = setDir'
            if (strcmp(model.name,'.') || strcmp(model.name,'..')), continue; end
            
            % limit examples per class to prevent class imbalances
            if strcmp(set.name,'train')
                if (train_count >= clip_cls)
                    continue; 
                else
                    train_count = train_count + 1;
                end
            end
            
            MODELPATH_OFF = fullfile(mdlnetdir,class.name,set.name,model.name);
            [vertices, faces] = read_off(MODELPATH_OFF);

            FV.faces = faces';
            FV.vertices = vertices';
%             volume = VOXELISE(dim,dim,dim,FV);
            volume = polygon2voxel(FV,[dim dim dim],'auto','TRUE','TRUE');
            
            volume = padarray(volume, [pad pad pad]);

            mdb.data(:,:,:,end+1) = volume;
            mdb.set(end+1,1) = mdb.meta.set_names(set.name);
            mdb.class(end+1,1) = mdb.meta.class_names(class.name);
            
%             %% visualization 1
%             figure(1) 
%             [X,Y,Z]=ind2sub(size(volume),find(volume(:)));
%             plot3(X,Y,Z,'.');
%             axis equal;
%             axis([0 dim 0 dim 0 dim])
%             xlabel('x');
%             ylabel('y');
%             zlabel('z');
%             pause()

            iter = iter + 1;
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
