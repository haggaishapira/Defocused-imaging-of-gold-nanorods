function register_area_Callback(hObject, eventdata, handles)

    handles = register_area(handles,1);
    
    update_handles(handles.figure1, handles);
