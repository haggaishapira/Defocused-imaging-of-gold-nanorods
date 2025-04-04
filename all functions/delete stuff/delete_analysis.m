function handles = delete_analysis(handles,file_num)

    handles = delete_all_display_objects(handles,file_num);
    empty_analysis = make_empty_analysis();

    handles.analyses(file_num) = empty_analysis;
    update_analysis_mode_list_value(handles,empty_analysis.analysis_mode);
    handles = initialize_molecule_list(handles, empty_analysis.molecules);

    
