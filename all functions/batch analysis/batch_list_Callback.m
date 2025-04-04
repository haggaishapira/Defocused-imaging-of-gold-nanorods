function batch_list_Callback(hObject, eventdata, handles)

    file_num = handles.current_file_num;
    handles = delete_all_display_objects(handles,file_num);    
        
    file_nums = get_selected_file_nums_in_batch(handles);

    handles.file_list.Value = file_nums;

    handles = select_file(handles,file_nums(1),1);


    update_handles(hObject,handles);

















