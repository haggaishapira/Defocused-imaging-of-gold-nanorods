function decrease_min_seg_Callback(hObject, eventdata, handles)

    curr_min_seg = str2num(handles.min_seg.String);
    curr_min_seg = max(curr_min_seg - 1,1);

    handles.min_seg.String = num2str(curr_min_seg);

    handles = set_segment(handles);
    
    update_handles(handles.figure1,handles);