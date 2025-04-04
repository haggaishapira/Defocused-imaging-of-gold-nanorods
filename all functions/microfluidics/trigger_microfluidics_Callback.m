function trigger_microfluidics_Callback(hObject, eventdata, handles)
    
    if handles.trigger_microfluidics.Value && ~handles.microfluidics_connected
        handles.trigger_microfluidics.Value = 0;
        msgbox('microfluidics not connected');
    end

    update_handles(handles.figure1,handles);