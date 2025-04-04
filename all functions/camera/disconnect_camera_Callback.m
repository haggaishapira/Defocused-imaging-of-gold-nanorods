function disconnect_camera_Callback(hObject, eventdata, handles)
    handles = close_camera(handles);
    update_handles(handles.figure1,handles);
