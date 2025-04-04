function check_field_differences(existing_struct, loaded_struct, type_str, log)

    existing_field_names = fieldnames(existing_struct);
    loaded_field_names = fieldnames(loaded_struct);

    extra_in_existing = setdiff(existing_field_names,loaded_field_names);
    extra_in_loaded = setdiff(loaded_field_names,existing_field_names);

    if log
        fprintf('loading struct of type %s, filling only existing fields by overwriting with loaded fields with the same names.\nextra fields are incompatible.\n',type_str)
    
        num_extra = size(extra_in_existing,1);
        
        fprintf('%d extra fields in existing struct of type %s:\n', num_extra, type_str);
        disp(extra_in_existing);
        disp('');
    
    
        num_extra = size(extra_in_loaded,1);
        fprintf('%d extra fields in loaded struct of type %s:\n', num_extra, type_str);
        disp(extra_in_loaded);
        disp('');
    end