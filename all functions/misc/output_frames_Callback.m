function output_frames_Callback(hObject, eventdata, handles)
    num = str2num(handles.output_frames.String);
    if num > handles.vid_len
        num = handles.vid_len;
        handles.output_frames.String = num2str(num);
    end
    handles.slider_frames.Value = num;
    handles = frame_changed(handles,0,0);
    
    update_handles(handles.figure1, handles);
