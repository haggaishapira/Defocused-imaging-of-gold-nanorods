function [sequence_info,file_num] = get_current_sequence_info(handles)

    file_num = handles.current_file_num;
    sequence_info = handles.sequence_infos(file_num);