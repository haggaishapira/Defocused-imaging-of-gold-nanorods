function toggle_numbers_Callback(hObject, eventdata, handles)
    
    [molecules,num_mol] = get_current_molecules(handles);

    toggle_numbers(handles,molecules,num_mol);
