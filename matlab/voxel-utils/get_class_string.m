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
            cl = 'air';
        case 1
            cl = 'bowl';
        case 2
            cl = 'cap';
        case 3
            cl = 'cereal_box';
        case 4
            cl = 'coffee_mug';
        case 5
            cl = 'coffee_table';
        case 6
            cl = 'office_chair';
        case 7
            cl = 'soda_can';
        case 8
            cl = 'sofa';
        case 9
            cl = 'table';
        case 10
            cl = 'background';
    end
end

end