function stop_Callback(hObject, eventdata, handles)
%     handles = guidata(hObject);
    setappdata(0,'stop',1);
    update_handles(handles.figure1, handles);
