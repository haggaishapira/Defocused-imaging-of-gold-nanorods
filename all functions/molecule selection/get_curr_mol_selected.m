function molecule = get_curr_mol_selected(handles)
    
    index = get_mol_index_from_selected(handles);
    [current_molecules,num_mol_curr] = get_current_molecules(handles);
    molecule = current_molecules(index);
    