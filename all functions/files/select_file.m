function handles = select_file(handles,file_num,update_registered)
    
    

    handles.current_file_num = file_num;
    file_metadata = handles.file_metadatas(file_num);

    initialize_ax_video(handles,file_metadata.vid_size(1));

    handles = apply_file_metadata(handles,file_metadata,0);
    handles.frame = update_frame(handles,round(handles.slider_frames.Value));
    analysis = get_current_analysis(handles);
    update_analysis_mode_list_value(handles,analysis.analysis_mode);
    analysis.molecules = add_molecule_ROI_handles(handles, analysis.molecules, 0);
    [analysis,handles.all_lines,handles.all_lines_reference] = add_molecule_arrows_and_numbers(handles, analysis, 0);
    
    if analysis.num_mol>0
%         analysis = perform_extra_molecule_calculations(analysis);
        analysis.molecules = sort_molecules(handles,analysis.molecules,analysis.num_mol);
    end
    handles = initialize_molecule_list(handles, analysis.molecules);
    handles = set_analysis(handles,file_num,analysis,0);
    handles = frame_changed(handles,1,1);

    %%% new - for easy area searching process %%%
    print = 0;
    if update_registered
        handles = register_area(handles,print);
        handles = register_current_positions(handles,print);

        % update targets - x,y,z
        handles.stage_x_target.String = num2str(analysis.x_coord);
        handles.stage_y_target.String = num2str(analysis.y_coord);
        handles.piezo_z_target.String = num2str(analysis.z_coord);

    end
    %%% 





    