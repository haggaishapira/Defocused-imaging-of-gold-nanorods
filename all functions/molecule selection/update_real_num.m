function handles = update_real_num(handles)
    
    if ~isempty(handles.molecule_list.Value)
        molecule = get_curr_mol_non_selected(handles);
    else
        molecule = get_curr_mol_selected(handles);
    end

    handles.curr_mol_real_num = molecule.num;

