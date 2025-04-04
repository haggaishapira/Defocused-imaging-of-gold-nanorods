function delete_batch_Callback(hObject, eventdata, handles)


    batch_num = handles.batch_list.Value;
    num_batches = size(handles.batches,1);

    if num_batches == 0
%         handles.batch_list.Value = 1;
%         update_handles(hObject,handles);
        return;
    end

    if batch_num == num_batches
        new_batch_num = batch_num-1;
    else
        new_batch_num = batch_num;
    end    
    
%     new_batch_num = 0;
    handles.batch_list.String(batch_num,:) = [];
    handles.batch_list.Value = new_batch_num;
    handles.batch_list.Max = num_batches - 1;

    handles.batches(batch_num,:) = [];

    update_handles(hObject,handles);
