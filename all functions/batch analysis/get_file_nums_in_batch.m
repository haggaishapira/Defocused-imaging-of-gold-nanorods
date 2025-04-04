function file_nums = get_file_nums_in_batch(handles,batch_num)


    batch = handles.batches(batch_num);
    id_nums = batch.id_nums;
    all_id_nums = cell2mat({handles.file_metadatas.id_num});
    file_nums = [];
    for i=1:length(id_nums)
        file_num = find(all_id_nums == id_nums(i));
        file_nums = [file_nums file_num];
    end