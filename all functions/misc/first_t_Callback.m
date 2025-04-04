function first_t_Callback(hObject, eventdata, handles)
    [file_metadata,file_num] = get_current_file_metadata(handles);
    framerate = file_metadata.framerate;

    first_t = str2num(handles.first_t.String);    
    last_t = str2num(handles.last_t.String);    
    if first_t < 0
        handles.first_t.String = num2str(0);
    end
    if first_t > last_t
        handles.first_t.String = num2str(last_t);
    end
    curr_frame = round(first_t*framerate);
    curr_frame = max(curr_frame,1);
    curr_frame = min(curr_frame,file_metadata.vid_len);
    handles.slider_frames.Value = curr_frame;
    handles = frame_changed(handles,1,0);
    update_handles(handles.figure1, handles);