function delete_analysis_Callback(hObject, eventdata, handles)

    file_num = handles.current_file_num;
    handles = delete_analysis(handles,file_num);
    update_handles(handles.figure1, handles);
