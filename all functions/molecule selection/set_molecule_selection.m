function handles = set_molecule_selection(handles,molecule_selection)

    file_num = handles.current_file_num;
    handles.molecule_selections{file_num} = molecule_selection;