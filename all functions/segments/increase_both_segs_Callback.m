function increase_both_segs_Callback(hObject, eventdata, handles)

    [sequence_info,file_num] = get_current_sequence_info(handles);
    num_seg = length(sequence_info.command_names_full_sequence);

    curr_max_seg = str2num(handles.max_seg.String);
    curr_min_seg = str2num(handles.min_seg.String);
    
%     interval = 120;
    interval = str2num(handles.interval_segments.String);

    if curr_max_seg + interval <= num_seg
        curr_min_seg = curr_min_seg + interval;
        curr_max_seg = curr_max_seg + interval;
        handles.min_seg.String = num2str(curr_min_seg);
        handles.max_seg.String = num2str(curr_max_seg);
    end

    handles = set_segment(handles);
    update_handles(handles.figure1,handles);