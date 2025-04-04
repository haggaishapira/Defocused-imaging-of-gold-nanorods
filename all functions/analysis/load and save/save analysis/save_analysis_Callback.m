function save_analysis_Callback(hObject, eventdata, handles)
    
    [file_metadata,file_num] = get_current_file_metadata(handles);
    analysis = handles.analyses(file_num);

%     save_analysis_v7(handles,0);
%     save_analysis_v7(file_metadata,analysis,0);

%     custom_name = handles.save_analysis_custom_name.Value;
    custom_name = handles.custom_name.Value;
%     custom_name = 0;

    save_analysis_v7(analysis,file_metadata.full_name,0,custom_name);



    
