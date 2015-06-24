function cl = get_class_string(idx, scene)

if ~scene
    switch idx
        case 0
            cl = 'bathtub';
        case 1
            cl = 'bed';
        case 2
            cl = 'chair';
        case 3
            cl = 'desk';
        case 4
            cl = 'dresser';
        case 5
            cl = 'monitor';
        case 6
            cl = 'night_stand';
        case 7
            cl = 'sofa';
        case 8
            cl = 'table';
        case 9
            cl = 'toilet';
    end
else
    switch idx
        case 0
            cl = 'bowl';
        case 1
            cl = 'cap';
        case 2
            cl = 'cereal_box';
        case 3
            cl = 'coffee_mug';
        case 4
            cl = 'coffee_table';
        case 5
            cl = 'office_chair';
        case 6
            cl = 'soda_can';
        case 7
            cl = 'sofa';
        case 8
            cl = 'table';
        case 9
            cl = 'background';
    end
end

end