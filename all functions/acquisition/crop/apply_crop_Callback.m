function apply_crop_Callback(hObject, eventdata, handles)

    position = handles.crop_handle.Position;
    position = round(position);
    disp(position);

    % correct for binning on crop selection time
    position = position * handles.crop_factor;

    handles.crop_ROI = position;

    delete(handles.crop_handle);

    update_handles(handles.figure1,handles);
