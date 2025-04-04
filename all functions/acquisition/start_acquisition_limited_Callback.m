function start_acquisition_limited_Callback(hObject, eventdata, handles)
    
%     limited = 1;
    handles = start_acquisition(handles,1);
    update_handles(handles.figure1, handles);
