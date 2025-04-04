function analysis = get_current_analysis(handles)
    if handles.num_files == 0
        analysis = [];
    else
        curr_file = handles.current_file_num;
        analysis = handles.analyses(curr_file);
    end