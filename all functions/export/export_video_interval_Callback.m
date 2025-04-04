function export_video_interval_Callback(hObject, eventdata, handles)
  
    handles = recalculate_export_parameters(handles);
    update_handles(handles.figure1, handles);
