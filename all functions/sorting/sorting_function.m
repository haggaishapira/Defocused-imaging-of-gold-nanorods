function sorted_molecules = sorting_function(molecules,num_mol,field_str,curr_frame)

    data = get_specific_data_from_field(molecules,field_str,curr_frame);

    for i=1:num_mol
        molecules(i).sorting_val = data(i);
    end

%     find number
    found = 0;
    names = fieldnames(molecules);
    for i=1:size(names,1)
        if strcmp(names{i},'sorting_val')
            field_num = i;
            found = 1;
            break;
        end
    end
    if found
        sorted_molecules = sort_struct_by_field(molecules, field_num);
    else
        msgbox('error sorting');
    end






