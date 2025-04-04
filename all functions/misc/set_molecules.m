function handles = set_molecules(handles,file_num,molecules)
    molecule_set.molecules = molecules;
    if size(handles.molecule_sets,1) < file_num
        handles.molecule_sets = [handles.molecule_sets; molecule_set];
    else
        handles.molecule_sets(file_num,:) = molecule_set;
    end