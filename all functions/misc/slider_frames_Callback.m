function slider_frames_Callback(hObject, eventdata, handles)
    if nargin == 2
%         return;
        handles = getappdata(0,'handles');
        handles = frame_changed(handles,0,0);
        update_handles(handles.figure1,handles);       
        return;
    else
        if handles.listener.Enabled
            return;
        end
    end
    handles = frame_changed(handles,0,0);
    update_handles(handles.figure1,handles);       
