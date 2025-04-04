function handles = set_segment(handles)

    [sequence_info,file_num] = get_current_sequence_info(handles);
    num_seg = length(sequence_info.command_names_full_sequence);

    min_seg = str2num(handles.min_seg.String);
    max_seg = str2num(handles.max_seg.String);
    
    first_t = sequence_info.time_intervals(min_seg,1);
    last_t = sequence_info.time_intervals(max_seg,2);

    handles.first_t.String = num2str(first_t);
    handles.last_t.String = num2str(last_t);

    analysis = get_current_analysis(handles);

    [file_metadata,file_num] = get_current_file_metadata(handles);
    framerate = file_metadata.framerate;
    frame_start = max(1,round(first_t*framerate));

    handles.slider_frames.Value = frame_start;
% 
    handles = frame_changed(handles,1,0);


    