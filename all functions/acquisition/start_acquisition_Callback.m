function start_acquisition_Callback(hObject, eventdata, handles)
    
    limited = 0;
    handles = start_acquisition(handles,limited);
    update_handles(handles.figure1, handles);
