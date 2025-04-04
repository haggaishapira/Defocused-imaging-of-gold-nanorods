function non_selected = get_non_selected(handles)

    molecule_selection = get_current_molecule_selection(handles);
    [current_molecules,num_mol_curr] = get_current_molecules(handles);
    all_mol_nums = cell2mat({current_molecules.num});
    non_selected = setdiff(all_mol_nums,molecule_selection);