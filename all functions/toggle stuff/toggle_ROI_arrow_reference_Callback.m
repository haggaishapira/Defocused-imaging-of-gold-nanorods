function toggle_ROI_arrow_Callback(hObject, eventdata, handles)

    handles = toggle_ROI_arrow_reference(handles);

    pause(0.01);

    update_handles(handles.figure1, handles);