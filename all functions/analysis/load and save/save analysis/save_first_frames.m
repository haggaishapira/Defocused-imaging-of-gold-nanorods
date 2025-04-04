function save_first_frames(handles,first_frames)

    file_num = handles.file_list.Value;
    file_metadata = handles.file_metadatas(file_num);
    
    [pathname, filename, extension] = fileparts(file_metadata.full_name);
    path_and_filename = [pathname '\' filename];
    
    save([path_and_filename '_first_frames' '.mat'],'first_frames','-mat');
%     msgbox('analysis saved successfully');
