
function handles = disconnect_piezo(handles)

    try
        piezo = handles.piezo;
        piezo.CloseConnection;
        piezo.Destroy;
        handles.piezo = [];
        disp('successfully closed piezo');
%         msgbox('successfully closed piezo');
        handles.piezo_connected_output.String = 'disconnected';
        handles.piezo_connected_output.BackgroundColor = [1 0 0];
    catch e
        disp('error closing piezo');
        msgbox('error closing piezo');
        disp(e);
    end
    
    % clear Controller;
    % clear PIdevice;