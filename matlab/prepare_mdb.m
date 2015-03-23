dim = 32;
mdb.data = false(dim,dim,dim,0);
mdb.set = zeros(0,1);
mdb.class = zeros(0,1);

mdb.meta.set_names = containers.Map({'train', 'test'}, {0, 1});
mdb.meta.class_names = containers.Map;

rawDataDir = dir('ModelNet10');
for class = rawDataDir'

    if (~isdir(fullfile('ModelNet10',class.name)) || ...
            strcmp(class.name,'.') || strcmp(class.name,'..')), continue; end
    
    if ~isKey(mdb.meta.class_names, class.name)
        mdb.meta.class_names(class.name) = length(mdb.meta.class_names);
    end
    
    testTrainDir = dir(fullfile('ModelNet10',class.name));
    
    for set = testTrainDir'
        
        setDir = dir(fullfile('ModelNet10',class.name,set.name));
        if (strcmp(set.name,'.') || strcmp(set.name,'..')), continue; end

        for model = setDir'
            if (strcmp(model.name,'.') || strcmp(model.name,'..')), continue; end
            
            MODELPATH_OFF = fullfile('ModelNet10',class.name,set.name,model.name);
            [vertices, faces] = read_off(MODELPATH_OFF);

            FV.faces = faces';
            FV.vertices = vertices';
            
            volume = VOXELISE(dim,dim,dim,FV);
%             volume = polygon2voxel(FV,[dim dim dim],'auto');

            mdb.data(:,:,:,end+1) = volume;
            mdb.set(end+1,1) = mdb.meta.set_names(set.name);
            mdb.class(end+1,1) = mdb.meta.class_names(class.name);

            %% visualization 1
            figure(1) 
            [X,Y,Z]=ind2sub(size(volume),find(volume(:)));
            plot3(X,Y,Z,'.');
            axis equal;
            xlabel('x');
            ylabel('y');
            zlabel('z');
            pause()
        end
        
    end
    x = 1;

end