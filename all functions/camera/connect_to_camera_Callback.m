function connect_to_camera_Callback(hObject, eventdata, handles)

    try 
        handles = initialize_camera(handles);
    catch e
        disp('failed to connect camera');
        msgbox('failed to connect camera');
        disp(e);
    end
    update_handles(handles.figure1,handles);
