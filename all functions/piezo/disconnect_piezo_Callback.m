function disconnect_piezo_Callback(hObject, eventdata, handles)

    handles = disconnect_piezo(handles);
    update_handles(handles.figure1, handles);
