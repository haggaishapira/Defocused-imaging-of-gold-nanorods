function save_sequence_info_Callback(hObject, eventdata, handles)

    [file_metadata,~] = get_current_file_metadata(handles);
    [sequence_info,~] = get_current_sequence_info(handles);

    save_sequence_info(sequence_info,file_metadata.full_name,0,0);
    
    msgbox('saved sequence sucesfully');
