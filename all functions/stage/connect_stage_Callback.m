function connect_stage_Callback(hObject, eventdata, handles)


    DeviceObj = DeviceControl;
    handles.DeviceObj = DeviceObj; 


    COMport = 'COM6';
    DeviceObj = handles.DeviceObj.ConfigSerialport(char(COMport));
    handles.DeviceObj = DeviceObj; 
    handles.DeviceObj.XTotalTravel = 0; 
    handles.DeviceObj.YTotalTravel = 0; 
    
    handles.stage_x_current.String = num2str(0);
    handles.stage_y_current.String = num2str(0);

    if ~handles.DeviceObj.IsComEnabled
%       set(handles.stage_connected_output,'string','COMport open failed');
      msgbox('COMport open failed');
      return;
    end
    
    status = handles.DeviceObj.Connect();
    if status
        set(handles.stage_connected_output,'string','Connected');
        handles.stage_connected_output.BackgroundColor = [0 1 0];

    else
        set(handles.stage_connected_output,'string','Disconnected');
        handles.stage_connected_output.BackgroundColor = [1 0 0];
%         msgbox('Device Not Connected');
    end

    disp('stage connected.');

    update_handles(handles.figure1, handles);



