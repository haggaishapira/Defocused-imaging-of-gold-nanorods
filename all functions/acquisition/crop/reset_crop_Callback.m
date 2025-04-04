function reset_crop_Callback(hObject, eventdata, handles)

    handles.crop_ROI = [1 1 512 512];
    update_handles(handles.figure1,handles);
