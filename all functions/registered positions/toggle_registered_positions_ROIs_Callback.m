function toggle_registered_positions_ROIs_Callback(hObject, eventdata, handles)

    handles = toggle_registered_positions_ROIs(handles);
    
    update_handles(handles.figure1, handles);

    
