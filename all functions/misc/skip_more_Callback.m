function skip_more_Callback(hObject, eventdata, handles)

    skip = str2num(handles.skip_frames.String);
    skip = round(skip * 10);
% 
    [file_metadata,file_num] = get_current_file_metadata(handles);
    vid_len = file_metadata.vid_len;
    if skip > vid_len-1
        return;
    end
% 
    handles.skip_frames.String = num2str(skip);
    handles.slider_frames.SliderStep = (handles.slider_frames.SliderStep) * 10;
    update_handles(handles.figure1,handles);
