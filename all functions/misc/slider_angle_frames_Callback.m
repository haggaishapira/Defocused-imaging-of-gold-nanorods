function slider_angle_frames_Callback(hObject, eventdata, handles)
    handles.angle_frames_curr_ind = round(hObject.Value);
    handles = show_current_angle_frame(handles);
    update_handles(handles.figure1,handles);       
