function file_nums = get_selected_file_nums_in_batch(handles)

    % selected_id_nums
    file_selection = handles.file_list.Value;
    file_metadatas = handles.file_metadatas(file_selection);
    id_nums = cell2mat({file_metadatas.id_num});

%     selected_id_nums = ;

    % find relevant batch
    num_batches = size(handles.batches,1);

    found = 0;
    for i=1:num_batches
        batch = handles.batches(i);
        inds = [];
        for j=1:length(id_nums)
            id_num = id_nums(j);
            ind = find(batch.id_nums == id_num);
            inds = [inds ind];
        end
        
        if ~isempty(inds)
            found = 1;
            break;
        end
    end

    if ~found
        return;
    end

    % 1 selection
%     index_in_batch = ind;

    % many selections
    

    batch_num = handles.batch_list.Value;
    batch = handles.batches(batch_num);

    % 1 selection
%     new_id_num = batch.id_nums(ind);
    
%     many selections
    new_id_nums = batch.id_nums(inds);

    % find in file list
    all_id_nums = cell2mat({handles.file_metadatas.id_num});
%     file_num = find(all_id_nums == new_id_num);

    % get all file nums
    file_nums = [];
    for i=1:length(new_id_nums)
        file_num = find(all_id_nums == new_id_nums(i));
        file_nums = [file_nums file_num];
    end
