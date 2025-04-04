function handles = microfluidics_now_disconnected(handles)

    delete(handles.microfluidics_connection);
    handles.microfluidics_connected = 0;
    handles.microfluidics_connected_output.String = 'Disconnected';
    handles.microfluidics_connected_output.BackgroundColor = [1 0 0];        
