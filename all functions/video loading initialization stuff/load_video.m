function handles = load_video(handles,filename_with_ext,pathname)

    full_name = [pathname,filename_with_ext];

    largest_id_num = handles.largest_id_num;
    empty_file_metadata = make_empty_file_metadata(largest_id_num + 1);
    handles.largest_id_num = handles.largest_id_num + 1;
    
    [handles,file_metadata,error] = initialize_file(handles,full_name,empty_file_metadata);
    file_metadata.id_num = largest_id_num;
    if error
        msgbox('bad file');
        return;
    end

    old_file_num = handles.current_file_num;
    handles = delete_all_display_objects(handles,old_file_num);

    sequence_info = load_sequence_info_wrapper(handles,file_metadata);
    handles.sequence_infos = [handles.sequence_infos; sequence_info];

    [handles,new_file_num] = apply_file_metadata(handles,file_metadata,1);
    handles.file_list.Value = new_file_num;
%     dim_vid = file_metadata.vid_size(1);
    vid_size = file_metadata.vid_size;
    dim_vid = min(vid_size(1),vid_size(2));
    
    initialize_ax_video(handles,dim_vid);
%     handles.frame = update_frame(handles,1);

    % load first frames
    [pathname, filename, extension] = fileparts(file_metadata.full_name);
    first_frames_filename = [pathname '\' filename '_first_frames' '.mat'];
    if isfile(first_frames_filename)
        load(first_frames_filename);
        handles.file_metadatas(new_file_num).first_frames = first_frames;
    end


    general_settings = handles.general_settings;
    default_first_t = general_settings.default_first_t;
%     default_last_t = general_settings.default_last_t;

    if file_metadata.duration > default_first_t
        t_start = min(default_first_t,file_metadata.duration);
        framerate = file_metadata.framerate;
        frame_start = round(t_start*framerate);
        frame_start = max(frame_start,1);
    else
        frame_start = 1;
    end

    handles.slider_frames.Value = frame_start;


    % correct for delay in sequences
%     sequence_info.time_intervals = sequence_info.time_intervals * 1.0005;
%     sequence_info.time_intervals = sequence_info.time_intervals * 1.0001;


    load_analysis_also = handles.load_analysis.Value;
    if load_analysis_also
%         [pathname, filename, extension] = fileparts(full_name);
        analysis = load_analysis_wrapper(handles,file_metadata);
        % selection
        handles = load_molecule_selection(handles);
%         selection = get_current_molecule_selection(handles);
        analysis = perform_extra_calculations(handles,analysis,new_file_num,1,1);
    else
%         handles = set_molecules(handles,file_num,[]);
        analysis = make_empty_analysis();
    end
    update_analysis_mode_list_value(handles,analysis.analysis_mode);
    analysis.molecules = add_molecule_ROI_handles(handles, analysis.molecules, 0);
    [analysis,handles.all_lines,handles.all_lines_reference] = add_molecule_arrows_and_numbers(handles, analysis, 0);
    if analysis.num_mol>0
        analysis.molecules = sort_molecules(handles,analysis.molecules,analysis.num_mol);
    end

%     handles.curr_mol_num_non_selected = 

    handles = initialize_molecule_list(handles, analysis.molecules);

%     if analysis.num_mol>0
%         if isempty(selection)
%             handles.molecule_list.Value = 1;
%             handles.selected_molecules_list.Value = [];
%         else
%             handles.molecule_list.Value = [];
%             handles.selected_molecules_list.Value = 1;
%         end
%     end

    handles = set_analysis(handles,new_file_num,analysis,1);
%     handles = write_data_in_table(handles);


    handles.listener_switch.Value = 0;
    handles.listener.Enabled = 0;

    %     handles.slider_frames.Value = 1;



%     handles.listener_switch.Value = 1;
%     handles.listener.Enabled = 1;


    handles = frame_changed(handles,1,1);









    
