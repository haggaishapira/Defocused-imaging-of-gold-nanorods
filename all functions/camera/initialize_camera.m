function handles = initialize_camera(handles)
%     ret = AndorInitialize('C:\Program Files\MATLAB\R2021b\toolbox\Andor\ToolBox');
    addpath('c:\Program Files\MATLAB\R2021b\toolbox\Andor\');
%     ret = AndorInitialize('C:\Users\Public\Documents\Matlab\ToolBox\Andor');
    ret = AndorInitialize('c:\Program Files\MATLAB\R2021b\toolbox\Andor\');
    
    CheckError(ret);
%     handles.camera.shutter = 'closed';
%     handles.camera.cooler = 'off';
%     handles.camera.temperature = 20;
    [ret] = SetReadMode(4);
    CheckWarning(ret);
    [ret] = SetTriggerMode(0);
    CheckWarning(ret);
    SetImageRotate(2);    
    CheckWarning(ret);
    [ret] = SetEMCCDGain(30);
    CheckWarning(ret);
%     ret = SetShutter(1,1,1,1);
%     CheckWarning(ret);
    ret = CoolerON();
    CheckWarning(ret);
    ret = SetTemperature(-80);
    CheckWarning(ret);    
    show_temp(handles);

%     SetImageFlip(2);
%     msgbox('connected camera successfully');
    handles.camera_connected_output.String = 'connected';
    handles.camera_connected_output.BackgroundColor = [0 1 0];


    
    