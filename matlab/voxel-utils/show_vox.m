function show_vox( vox , num_labels )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    if nargin < 2
        colored = false;
    else
        colored = true;
    end

    if colored == false
        [X,Y,Z]=ind2sub(size(vox),find(vox(:)));
        plot3(X,Y,Z,'.');
        axis equal;
        xlabel('x');
        ylabel('y');
        zlabel('z');
    else
        clf
        clrs = colormap(jet(num_labels));
        hold off
        for i = 1:num_labels
            v = (vox == i);
            [X,Y,Z]=ind2sub(size(v),find(v(:)));
            plot3(X,Y,Z,'.','Color',clrs(i,:));
            hold on
        end
        axis equal;
        xlabel('x');
        ylabel('y');
        zlabel('z');
        colorbar
        for i=1:10
            uicontrol('Style', 'text', ...
            'String', get_class_string(i,true),... 
            'Units','normalized',...
            'Position', [0.91 (i/11) 0.1 0.03]); 
end
        hold off
    end

end

