function microfluidics_connected_output_Callback(hObject, eventdata, handles)

    
    if handles.microfluidics_connected 
        % check for update
        conn = handles.microfluidics_connection;

        try 
            data = read(conn,conn.NumBytesAvailable,'string');
%             disp(data); 
            other_side_terminated = strcmp(data,'2');        
            if other_side_terminated
                connection_ok = 0;
            else
                connection_ok = test_connection(handles.microfluidics_connection);
                if connection_ok
                    msgbox('connection ok');
                end
            end
        catch e
            connection_ok = 0;
        end

        if ~connection_ok
            handles = microfluidics_now_disconnected(handles);
        end        
    else
        handles = microfluidics_now_disconnected(handles);
    end
    
   
    update_handles(handles.figure1,handles);




