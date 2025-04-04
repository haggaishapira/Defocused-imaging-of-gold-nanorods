function update_analysis_mode_list_value(handles,str)

    ind = find(contains(handles.current_analysis_mode.String,str));
    handles.current_analysis_mode.Value = ind;