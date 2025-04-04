function figure1_CloseRequestFcn(hObject, eventdata, handles)
    

%     close_camera();
    if isfield(handles,'piezo') && ~isempty(handles.piezo)
        disconnect_piezo(handles);
    else
        disp('piezo disconnected, no need to disconnect');
    end
    
    delete(hObject);    
