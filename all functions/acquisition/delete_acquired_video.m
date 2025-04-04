function handles = delete_acquired_video(handles,acq)

    file_metadatas = acq.file_metadatas;
    for i=1:size(file_metadatas,2)
        delete(file_metadatas{1,i});
    end

