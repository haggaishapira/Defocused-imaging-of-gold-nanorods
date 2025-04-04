function [file_metadata,file_num] = get_current_file_metadata(handles)

    file_num = handles.current_file_num;
    file_metadata = handles.file_metadatas(file_num);
