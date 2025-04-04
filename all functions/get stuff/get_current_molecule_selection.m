function molecule_selection = get_current_molecule_selection(handles)
    
    file_num = handles.current_file_num;
    molecule_selection = handles.molecule_selections{file_num};