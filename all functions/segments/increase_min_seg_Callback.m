function increase_min_seg_Callback(hObject, eventdata, handles)

    curr_max_seg = str2num(handles.max_seg.String);
    curr_min_seg = str2num(handles.min_seg.String);
    curr_min_seg = min(curr_min_seg + 1,curr_max_seg);
    handles.min_seg.String = num2str(curr_min_seg);

    handles = set_segment(handles);
    
    update_handles(handles.figure1,handles);