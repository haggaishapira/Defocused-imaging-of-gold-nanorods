function handles = close_camera(handles)
   
    try
        ret = CoolerOFF();
        CheckWarning(ret);
        [ret]=SetShutter(1, 2, 1, 1);
        CheckWarning(ret);
        [ret]=AndorShutDown;
        CheckWarning(ret);
%         msgbox('closed camera successfully');
        disp('closed camera successfully');
        handles.camera_connected_output.String = 'disconnected';
        handles.camera_connected_output.BackgroundColor = [1 0 0];
    catch e        
        msgbox('failed to close camera');
        disp('failed to close camera');
        disp(e);
    end
    
     