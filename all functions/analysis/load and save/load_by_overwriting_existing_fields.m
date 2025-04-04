function existing_struct = load_by_overwriting_existing_fields(existing_struct, new_struct_filename)

    % don't take new fields, only try to fill in existing, so no
    % compatibility problems
    try 
       loaded_struct_wrapper = load(new_struct_filename);
    catch e
        disp(e);
%         disp('error loading metadata or analysis');
        disp('error loading struct');
        return;
    end
    struct_name_field = fieldnames(loaded_struct_wrapper);
    struct_name_field = struct_name_field{1,1};
    loaded_struct = loaded_struct_wrapper.(struct_name_field);

    existing_field_names = fieldnames(existing_struct);
    num_fields = length(existing_field_names);

    % it doesnt matter which direction, we are looking at the intersection
    for i=1:num_fields
        field = existing_field_names{i};
        try
            existing_struct.(field) = loaded_struct.(field);
        catch e
        end
    end
    
    check_field_differences(existing_struct, loaded_struct, struct_name_field, 0);
    




