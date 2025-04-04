function piezo_down_Callback(hObject, eventdata, handles)

    settings = handles.piezo_settings;
    step_size = settings.step_size;

    piezo = handles.piezo;
    curr_pos = handles.piezo.qPOS('1');

    desired_pos = curr_pos - step_size;
    piezo_set_position(piezo,desired_pos);

    display_piezo_position(handles);

%     piezo_set_position(piezo,desired_pos);
    update_handles(handles.figure1, handles);