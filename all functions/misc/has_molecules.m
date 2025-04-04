function has = has_molecules(handles,file_num)
    molecule_set = handles.molecule_sets(file_num);
    has = ~isempty(molecule_set.molecules);