function file_num = file_num_from_id(handles,id_num)

%     analyses = handles.analyses;
    file_metadatas = handles.file_metadatas;
    id_nums = cell2mat({file_metadatas.id_num});

    file_num = find(id_nums == id_num);