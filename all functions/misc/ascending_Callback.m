function ascending_Callback(hObject, eventdata, handles)
    handles.ascending = 1;
    handles = sort_list(handles);
    update_handles(handles.figure1,handles);
