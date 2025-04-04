function disconnect_stage_Callback(hObject, eventdata, handles)

    handles.DeviceObj = [];
    set(handles.stage_connected_output,'string','Disconnected');
    handles.stage_connected_output.BackgroundColor = [1 0 0];