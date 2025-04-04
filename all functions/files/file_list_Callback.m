function file_list_Callback(hObject, eventdata, handles)
    
    if getappdata(0,'acquisition') 
        return;
    end
    file_num = handles.current_file_num;
    handles = delete_all_display_objects(handles,file_num);    

    if handles.num_files > 0
        file_num = hObject.Value;
        file_num = file_num(1);
        handles = select_file(handles,file_num,1);
    end


    update_handles(handles.figure1, handles);
    