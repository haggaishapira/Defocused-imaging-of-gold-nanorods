function reset_piezo_Callback(hObject, eventdata, handles)

    
    piezo = handles.piezo;
    settings = handles.piezo_settings;
    default_z = settings.default_z;

%     desired_pos = 50;
    piezo_set_position(piezo,default_z)

    display_piezo_position(handles);           
