function descending_Callback(hObject, eventdata, handles)
    handles.ascending = 0;
    handles = sort_list(handles);
    update_handles(handles.figure1,handles);
