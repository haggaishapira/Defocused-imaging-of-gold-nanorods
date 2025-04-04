function decrease_max_seg_Callback(hObject, eventdata, handles)

    curr_max_seg = str2num(handles.max_seg.String);
    curr_min_seg = str2num(handles.min_seg.String);
    curr_max_seg = max(curr_max_seg - 1,curr_min_seg);
    handles.max_seg.String = num2str(curr_max_seg);

    handles = set_segment(handles);
    
    update_handles(handles.figure1,handles);

