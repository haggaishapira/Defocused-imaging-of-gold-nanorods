function index = get_mol_index_from_selected(handles)

    [current_molecules,num_mol_curr] = get_current_molecules(handles);
    

    % need to replace this method with number based (convert strings to
    % numbers then work with them)
    val = handles.selected_molecules_list.Value;
    selected_mol_str = handles.selected_molecules_list.String{val};
    for i=1:num_mol_curr
        str = current_molecules(i).str;
        if strcmp(selected_mol_str,str)
            index = i;
            break;
        end
    end    