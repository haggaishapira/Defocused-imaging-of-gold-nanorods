function delete_file_Callback(hObject, eventdata, handles)

    handles = delete_file(handles);
    update_handles(hObject,handles);
    
