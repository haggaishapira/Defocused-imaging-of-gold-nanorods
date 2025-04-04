function listener_switch_Callback(hObject, eventdata, handles)
    listen = hObject.Value;
    if ~listen
%         delete(handles.listener);
        handles.listener.Enabled = 0;
    else
%         handles.listener_switch = addlistener(handles.slider_frames, 'Value', 'PreSet',@slider_frames_Callback);
        handles.listener.Enabled = 1;
    end
    update_handles(handles.figure1,handles);
