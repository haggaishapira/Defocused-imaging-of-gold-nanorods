function add_batch_Callback(hObject, eventdata, handles)

    file_selection = handles.file_list.Value;

    file_metadatas = handles.file_metadatas(file_selection);
    id_nums = cell2mat({file_metadatas.id_num});


    settings = handles.extra_calculations_settings;
    angle = settings.current_FH_angle;

    batch = make_empty_batch(id_nums,angle);

    num_batches = size(handles.batches,1);
    new_batch_num = num_batches+1;

    handles.batches = [handles.batches; batch];

    handles.batch_list.String{new_batch_num} = file_metadatas(1).filename;
    handles.batch_list.Value = num_batches+1;

    update_handles(hObject,handles);
