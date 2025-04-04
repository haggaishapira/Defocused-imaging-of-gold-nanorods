function file_nums = get_all_file_nums_in_selected_batch(handles)

    batch_num = handles.batch_list.Value;
    if isempty(handles.batches)
        msgbox('add batch first');
        return;
    end
    file_nums = get_file_nums_in_batch(handles,batch_num);