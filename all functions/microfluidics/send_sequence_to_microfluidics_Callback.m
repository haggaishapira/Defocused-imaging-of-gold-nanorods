function send_sequence_to_microfluidics_Callback(hObject, eventdata, handles)
 
    [sequence_info,file_num] = get_current_sequence_info(handles);
    [file_metadata,file_num] = get_current_file_metadata(handles);
    filename_sequence = [file_metadata.pathname '\' file_metadata.filename '_sequence_labview.txt'];

    send_sequence_to_microfluidics(handles,filename_sequence,sequence_info);







