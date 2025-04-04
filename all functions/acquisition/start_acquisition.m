function handles = start_acquisition(handles,limited)

%     clc
    warning off MATLAB:tifflib:TIFFReadDirectory:libraryWarning;    

    acq.limited = limited;
    % adds file
    [handles,acq,error] = initialize_acquisition(handles,acq);
    if error
        return;
    end
%     handles = initialize_molecule_list(handles, []);
    handles.acq = acq;
    accept = 1;

    % adds movie and molecules
    if acq.spool
        largest_id_num = handles.largest_id_num;
        file_metadata = make_empty_file_metadata(largest_id_num + 1);
        handles.largest_id_num = handles.largest_id_num + 1;
        
        [handles,file_metadata,new_file_num] = add_acquired_movie_to_list(handles,acq,file_metadata);
        handles = set_molecule_selection(handles,[]);
        if acq.trigger_microfluidics
%             file_metadata.sequence_info = acq.sequence_info;
            save_sequence_info(acq.sequence_info,file_metadata.full_name,1,0);            
        end
%         if acq.live_analysis
            handles.sequence_infos = [handles.sequence_infos; acq.sequence_info];
%         end
        if acq.live_analysis
%             analysis_settings = handles.analysis_settings;
            [handles,analysis_info,analysis,accept] = initialize_analysis(handles,1);
           
            switch analysis.analysis_mode
                case 'rotation'
                    if ~accept
                        acq.abort = 1;
                        acq.real_vid_len = 0;
                        handles = delete_file(handles);
                    else
                        [analysis,handles.all_lines,handles.all_lines_reference] = ...
                                            add_molecule_arrows_and_numbers(handles, analysis, 1);
                        handles = initialize_molecule_list(handles, analysis.molecules);
                        acq.analysis = analysis;   
                    end
                case 'immobilization'
                    % do nothing here
                case 'TIRF ensemble'
                    % do nothing here
                case 'finding focus'
                    if ~accept
                        acq.abort = 1;
                        acq.real_vid_len = 0;
%                         handles = delete_file(handles);                        
                    end
            end
            acq.analysis_info = analysis_info;   
            acq.analysis = analysis;   
        else
            analysis = make_empty_analysis();
        end
        handles = set_analysis(handles,new_file_num,analysis,1);
    end

    if ~acq.abort
        [handles,acq] = initialize_acquisition_body(handles,acq);
        [handles,acq] = acquisition_body(handles,acq);            
        if acq.live_analysis
            analysis = acq.analysis;
            analysis.z_coord = analysis.piezo_z(end);
        end
    end    

    if acq.abort && acq.spool 
%         handles = delete_file(handles);
%         return;
%         real_vid_len = acq.real_vid_len;
    end

    if acq.spool && accept
        file_metadata = get_current_file_metadata(handles);
        if acq.abort && acq.spool 
            real_vid_len = acq.real_vid_len;
            file_metadata.vid_len = real_vid_len;
            file_metadata.vid_size(3) = real_vid_len;
            if acq.live_analysis
                analysis.vid_len = real_vid_len;
            end
        end
        save_file_metadata(file_metadata);

        if acq.live_analysis
%             analysis = acq.analysis;
            if ~acq.abort
                first_t = handles.general_settings.default_first_t;
%                 first_t = num2str(10);
                if first_t >= file_metadata.duration
                    first_t = 0;
                    handles.general_settings.first_t = 0;
                end
                handles.first_t.String = num2str(first_t);
            end
            
            analysis = perform_extra_calculations(handles,analysis,new_file_num,1, 1);
        end
        handles = set_analysis(handles,new_file_num,analysis,0);
        handles = apply_filters(handles);
        if acq.live_analysis
%             save_analysis_v7(handles,1);
            save_analysis_v7(analysis,file_metadata.full_name,1,0)
            save_first_frames(handles,analysis_info.first_frames);
            handles.file_metadatas(new_file_num).first_frames = analysis_info.first_frames;

            % TIRF ensemble
            if strcmp(analysis.analysis_mode,'TIRF ensemble')
                export_TIRF_ensemble_trace(handles);
            end
        end
        if acq.abort && acq.spool 
            handles = delete_file(handles);
        end
        update_analysis_mode_list_value(handles,analysis.analysis_mode);
    end
    set(handles.slider_frames,'Value',1);
    set(handles.slider_frames,'Min',1,'Max',acq.vid_len,'SliderStep',[1/(acq.vid_len-1) 1/(acq.vid_len-1)]);
    
    if acq.spool
        handles = frame_changed(handles,1,1);
    end
%         save_analysis_v7(handles,1);
    
    

%     disp(handles.num_files);
    warning off MATLAB:tifflib:TIFFReadDirectory:libraryWarning;
%     clc








    