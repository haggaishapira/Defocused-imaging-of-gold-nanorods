function handles = load_sequence_info_from_mf(handles)

    if handles.num_files > 0
        [file_metadata,file_num] = get_current_file_metadata(handles);
        [pathname, filename, extension] = fileparts(file_metadata.full_name);
        filename_sequence = [pathname '\' filename '_sequence_info_offline'];
    else
        pathname = handles.pathname.String;
        filename_sequence = [pathname '\' 'default filename_sequence_info'];
    end

    sequence_info = read_sequence_info_3(handles,filename_sequence);
    disp('successfully loaded sequence info');
%     msgbox('successfully loaded sequence info');

    % new
    handles.current_sequence_info = sequence_info;

    if handles.num_files > 0
        file_num = handles.current_file_num;
        handles.sequence_infos(file_num) = sequence_info;    
        analysis = handles.analyses(file_num);
        handles = plot_graphs(handles,0,1,analysis,0);
    else
        disp('no files');
    end