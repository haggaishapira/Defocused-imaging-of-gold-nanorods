function molecule = get_disp_mol(handles)

    [molecules,num_mol] = get_current_molecules(handles);
    % list 1
    if ~isempty(handles.molecule_list.Value)
        val = handles.molecule_list.Value;
        disp_mol_str = handles.molecule_list.String{val};
    else
        val = handles.selected_molecules_list.Value;
        disp_mol_str = handles.selected_molecules_list.String{val};
    end

    for i=1:num_mol
        str = molecules(i).str;
        if strcmp(disp_mol_str,str)
            molecule = molecules(i);
            break;
        end
    end