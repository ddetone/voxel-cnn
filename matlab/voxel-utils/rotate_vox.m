function [Vox_rot] = rotate_vox(Vox, rot, tr, sc, display)

    rotX = rot.X;
    rotY = rot.Y;
    rotZ = rot.Z;
    rotZ = rotZ - 90; %TODO: fix offset z hack
    
    dim = size(Vox,1);

    xgrid = repmat(meshgrid(1:dim), [1 1 dim]);
    ygrid = repmat(meshgrid(1:dim)', [1 1 dim]);
    zgrid = permute(repmat(meshgrid(1:dim), [1 1 dim]), [3 1 2]);

    mask = zeros(3,dim*dim*dim);
    for i=1:dim
        for j=1:dim
            for k=1:dim
                idx = (i-1)*(dim*dim)+(j-1)*dim+(k-1)+1;
                mask(:,idx) = [xgrid(i,j,k) ygrid(i,j,k) zgrid(i,j,k)];
            end
        end
    end

    mask = mask - dim/2;
    mask(4,:) = 1;
    Rz = [ cosd(rotZ) -sind(rotZ)  0           0     ;
           sind(rotZ)  cosd(rotZ)  0           0     ;
           0           0           1           0     ;
           0           0           0           1     ;];
    Ry = [ cosd(rotY)  0           sind(rotY)  0     ;
           0           1           0           0     ;
          -sind(rotY)  0           cosd(rotY)  0     ;
           0           0           0           1     ;];
    Rx = [ 1           0           0           0     ;
           0           cosd(rotX) -sind(rotX)  0     ;
           0           sind(rotX)  cosd(rotX)  0     ;
           0           0           0           1     ;];
    S  = [sc           0           0           0     ;
          0            sc          0           0     ;
          0            0           sc          0     ;
          0            0           0           1     ;];
    T  = [1            0           0           tr.X  ;
          0            1           0           tr.Y  ;
          0            0           1           tr.Z  ;
          0            0           0           1     ;];         
    mask = T*Rx*Ry*Rz*S*mask;
    mask = mask ./ repmat(mask(4,:),[4 1]);
    mask = round(mask);
    mask = mask + dim/2;
    Vox_rot = zeros(dim,dim,dim);
    for i=1:dim
        for j=1:dim
            for k=1:dim
                idx = (i-1)*(dim*dim)+(j-1)*dim+(k-1)+1;
                x = mask(1,idx);
                y = mask(2,idx);
                z = mask(3,idx);
                if (x < 1 || x > dim || y < 1 || y > dim || ...
                        z < 1 || z > dim)
                    Vox_rot(i,j,k) = 0;
                else
                    Vox_rot(i,j,k) = Vox(x,y,z);
                end
            end
        end
    end


%     %visualization 1
    if display == true
        figure(1)
        subplot(1,2,1)
        [X,Y,Z]=ind2sub(size(Vox),find(Vox(:)));
        plot3(X,Y,Z,'.');
        axis equal;
        xlim([0 dim])
        ylim([0 dim])
        zlim([0 dim])
        xlabel('x');
        ylabel('y');
        zlabel('z');
        subplot(1,2,2)
        [X,Y,Z]=ind2sub(size(Vox_rot),find(Vox_rot(:)));
        plot3(X,Y,Z,'.');
        axis equal;
        xlim([0 dim])
        ylim([0 dim])
        zlim([0 dim])
        xlabel('x');
        ylabel('y');
        zlabel('z');
        pause(0.05);
    end

end
