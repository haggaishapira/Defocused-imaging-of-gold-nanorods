function max_seg_Callback(hObject, eventdata, handles)

    [sequence_info,file_num] = get_current_sequence_info(handles);
    num_seg = length(sequence_info.command_names_full_sequence);

    curr_max_seg = str2num(handles.max_seg.String);
    curr_max_seg = min(curr_max_seg,num_seg);
    handles.max_seg.String = num2str(curr_max_seg);

    handles = set_segment(handles);

    update_handles(handles.figure1,handles);