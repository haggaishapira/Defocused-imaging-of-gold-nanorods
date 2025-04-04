function transform_arr = get_transform_arr(num_mol)
    
%     channel 6 - 23_1_20
%     num_mol_arr = 15;
%     transform_nums = [ 2 3 7 9 11 12];

%     num_mol_arr = 23;
%     transform_nums = [5];

%     num_mol_arr = 1;
%     transform_nums = 1;

    num_mol_arr = 0;
    transform_nums = [];


%     num_mol_arr = 18;
%     transform_nums = 1:18;


    % channel 5 - 23_2_01
%     num_mol_arr = 19;
%     transform_nums = [1 4 5 7 9];
%     transform_nums = 1:19;

    if num_mol_arr == num_mol
            transform_arr = zeros(num_mol_arr,1);
        for i=1:num_mol_arr
            if ismember(i,transform_nums)
                transform_arr(i) = 1;
            end
        end
    else
        transform_arr = zeros(num_mol,1);
    end


