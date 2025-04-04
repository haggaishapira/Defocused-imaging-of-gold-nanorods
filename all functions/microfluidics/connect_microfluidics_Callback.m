function connect_microfluidics_Callback(hObject, eventdata, handles)

    try
        handles.microfluidics_connection = tcpclient("localhost",60000);
%         handles.microfluidics_connection = tcpclient("localhost",60000,'ConnectTimeout',1);

        connection_ok = test_connection(handles.microfluidics_connection);
        
        if connection_ok
            handles.microfluidics_connected = 1;
            handles.microfluidics_connected_output.String = 'Connected';
            handles.microfluidics_connected_output.BackgroundColor = [0 1 0];
        end
%         msgbox('connected to microfluidics');
    catch e
%         disp(e);
        msgbox('failed to connect to microfluidics');
    end

    update_handles(handles.figure1,handles);

    