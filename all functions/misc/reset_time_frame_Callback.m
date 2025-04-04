function reset_time_frame_Callback(hObject, eventdata, handles)

    [file_metadata,file_num] = get_current_file_metadata(handles);
%     framerate = file_metadata.framerate;

    handles.first_t.String = num2str(0);
    first_t_Callback(hObject, eventdata, handles);

    handles.last_t.String = num2str(file_metadata.duration);
    last_t_Callback(hObject, eventdata, handles);

