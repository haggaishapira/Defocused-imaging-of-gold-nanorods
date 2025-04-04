function handles = frame_changed(handles,initialize_all_plots,check_molecules_visibility)
    if handles.num_files == 0
        return;
    end

    file_num = handles.current_file_num;
    file_metadata = handles.file_metadatas(file_num);

    current_frame = round(handles.slider_frames.Value);
    display_frame_and_time(handles,current_frame,file_metadata.framerate);

%     if nargin < 3
        handles.frame = update_frame(handles,current_frame);
%     end
%     if has_molecules(handles,file_num)
    analysis = get_current_analysis(handles);
    handles = plot_graphs(handles,0,initialize_all_plots,analysis,check_molecules_visibility);
%     end
    if analysis.num_mol>0
%         handles = write_data_in_table(handles);
    end