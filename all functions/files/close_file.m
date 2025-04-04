function handles = close_file(handles)
    try
        if handles.file_id > -1    
            fclose(handles.file_id);
        end
        handles.file_id  = -1;
    catch e
            disp('error closing file');
    end
