function handles = analyze(handles)


    file_num = handles.current_file_num;
    handles = delete_analysis(handles,file_num);

    handles.listener_switch.Value = 0;
    handles.listener.Enabled = 0;
%     handles.slider_frames.Value = 1;
    handles = frame_changed(handles,1,1);

    [handles,analysis_info,analysis,accept] = initialize_analysis(handles,0); 
    if ~accept
%         handles = set_analysis(handles,file_num,analysis,0);
%         handles = delete_analysis(handles,file_num);
%         update_handles(handles.figure1, handles);
        return;
    end
    analysis_settings = handles.analysis_settings;

    fprintf('analyzing, %s mode\n', analysis.analysis_mode);
    switch analysis.analysis_mode
        case 'rotation'
            [analysis,handles.all_lines,handles.all_lines_reference] = ...
                add_molecule_arrows_and_numbers(handles, analysis, 1);
            handles = initialize_molecule_list(handles, analysis.molecules);

            analysis = analysis_rotation_mode(handles,analysis_settings,analysis_info,analysis);
            if accept
                analysis = perform_extra_calculations(handles,analysis, file_num, 0, 0);
        %     [handles,analysis]  = initialize_molecule_graphics(handles,analysis);
%                 [analysis,handles.all_lines,handles.all_lines_reference] = ...
%                                 add_molecule_arrows_and_numbers(handles, analysis, 1);
%                 handles = initialize_molecule_list(handles, analysis.molecules);
            else
                handles = set_analysis(handles,file_num,analysis,0);
                handles = delete_analysis(handles,file_num);
                update_handles(handles.figure1, handles);
                return;
            end
        case 'finding area'
            analysis = finding_area_offline_analysis(handles,analysis_info,analysis);
        case 'finding focus'
            analysis = finding_focus_offline_analysis(handles,analysis_settings,analysis_info,analysis);
        case 'immobilization'
            analysis = analysis_immobilization_mode(handles,analysis_settings,analysis_info,analysis);
        case 'TIRF ensemble'
            analysis = analysis_TIRF_ensemble(handles,analysis_settings,analysis_info,analysis);


    end
    update_analysis_mode_list_value(handles,analysis.analysis_mode);

    %% finalize analysis

    handles = set_analysis(handles,handles.current_file_num,analysis,0);

    if handles.autosave_analysis.Value
        [file_metadata,file_num] = get_current_file_metadata(handles);
        custom_name = handles.custom_name.Value;
        save_analysis_v7(analysis,file_metadata.full_name,0,custom_name);
%         save_analysis_v7(handles,0);
    end

%     handles = plot_graphs(handles,0,1);
    handles = frame_changed(handles,1,1);
%     toggle_ROI_squares(handles,molecules,num_mol);






