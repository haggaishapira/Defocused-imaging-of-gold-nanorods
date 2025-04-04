function output_time_Callback(hObject, eventdata, handles)
    t = str2num(handles.output_time.String);
    [file_metadata,file_num] = get_current_file_metadata(handles);
    framerate = file_metadata.framerate;

    frame_num = round(t*framerate);
    vid_len = file_metadata.vid_len;
    if frame_num > vid_len
        t = vid_len/framerate;
        handles.output_time.String = num2str(t);
        frame_num = vid_len;
    end
    if frame_num < 1
        t = 1/framerate;
        handles.output_time.String = num2str(t);
        frame_num = 1;
    end

    handles.slider_frames.Value = frame_num;
    handles = frame_changed(handles,0,0);
    
    update_handles(handles.figure1, handles);