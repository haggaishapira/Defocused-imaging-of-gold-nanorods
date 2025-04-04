function disconnect_microfluidics_Callback(hObject, eventdata, handles)

%     write(handles.microfluidics_connection,'2','string');
    
    response_ok = send_message_and_test_response(handles.microfluidics_connection,'2');
    if response_ok
    %     delete(handles.microfluidics_connection);
%         clear('handles.microfluidics_connection');
%        
%         handles.microfluidics_connected = 0;
%         handles.microfluidics_connected_output.String = 'Disconnected';
%         handles.microfluidics_connected_output.BackgroundColor = [1 0 0];
        handles = microfluidics_now_disconnected(handles);
    else
        msgbox('error in disconnecting');
    end
    update_handles(handles.figure1,handles);