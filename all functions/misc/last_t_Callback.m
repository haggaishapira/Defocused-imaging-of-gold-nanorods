function last_t_Callback(hObject, eventdata, handles)
    [file_metadata,file_num] = get_current_file_metadata(handles);
    first_t = str2num(handles.first_t.String);    
    last_t = str2num(handles.last_t.String);
    duration = file_metadata.duration;
    if last_t > duration
        handles.last_t.String = num2str(duration);
    end
    if last_t < first_t
        handles.last_t.String = num2str(first_t);
    end

    handles = frame_changed(handles,1,0);
    update_handles(handles.figure1, handles);