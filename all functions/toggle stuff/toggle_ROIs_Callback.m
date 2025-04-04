function toggle_ROIs_Callback(hObject, eventdata, handles)
    
    [molecules,num_mol] = get_current_molecules(handles);

    toggle_ROIs(handles,molecules,num_mol);
