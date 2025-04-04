function delete_all_batches_Callback(hObject, eventdata, handles)


    handles.batches = [];
    handles.batch_list.Value = 1;
    handles.batch_list.Max = 1;
    handles.batch_list.String = cell(0,1);
        
    update_handles(hObject,handles);
