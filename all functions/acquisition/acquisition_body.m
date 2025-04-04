function [handles,acq] = acquisition_body(handles,acq)

    if acq.live_analysis
        analysis_info = acq.analysis_info;
        analysis = acq.analysis;
        analysis_settings = handles.analysis_settings;
%         molecules = analysis.molecules;
        num_mol = analysis.num_mol;
    end

    handles.last_good_frame = [];

    acq.i_total = 1;
    acq.i_local = 1;
    while ~handles.stop_acquisition.Value
        
%         fprintf('i_total: %d\n',acq.i_total);
%         fprintf('i_local: %d\n',acq.i_local);
%         t_start = toc;
        if acq.limited && acq.i_total > acq.vid_len
            break;
        end
        
        if acq.limited
            handles.slider_frames.Value = acq.i_total;
            display_frame_and_time(handles,acq.i_total,acq.framerate);
        end


        [frame,bad] = get_frame_live(handles,acq,acq.i_local);


        if bad
%             frame = randi(1000,acq.dim_vid,acq.dim_vid);
            if acq.i_total == 1
                handles.frame = frame;
            else
                handles.frame = handles.last_good_frame;
            end
        else
            handles.frame = frame;
        end
        handles.last_good_frame = handles.frame;

        if acq.spool
            add_frame_to_resave_file(acq.resave_file_descriptor,uint16(frame));
        end


        if acq.i_total == 1
            save('frame1.mat','frame','-mat');
        end

        % send time to labview now
        if acq.trigger_microfluidics
            curr_t = acq.i_total/acq.framerate;
            send_time_to_mf(handles,curr_t);
        end

        if acq.live_analysis
            num_fr_collapse = analysis_info.num_frames_collapse;
            analysis_info.collapse = analysis_info.collapse + frame/num_fr_collapse;
            % bad to have double code but keep this for now
            if acq.i_total < analysis_info.finish_calibration_frame
                fit_z = analysis_settings.fit_z_initial && (acq.i_total == 1 || ~mod(acq.i_total,analysis_info.fit_z_initial_frame_interval));
                fit_xy = analysis_settings.fit_xy_initial && (acq.i_total == 1 || ~mod(acq.i_total,analysis_info.fit_xy_initial_frame_interval));
                calibration = 1;
                max_dist = analysis_settings.max_pix_from_initial_position;
            else
                fit_z = analysis_settings.fit_z_continuous && (acq.i_total > 1 && ~mod(acq.i_total,analysis_info.fit_z_continuous_frame_interval));
                fit_xy = analysis_settings.fit_xy_continuous && (acq.i_total > 1 && ~mod(acq.i_total,analysis_info.fit_xy_continuous_frame_interval));
                calibration = 0;
                max_dist = analysis_settings.max_pix_from_previous_position;
            end
                
            if fit_z
                params_to_opt = 3:5;
            else
                params_to_opt = 4:5;
            end
    
            fit_xy_single_molecule = (fit_xy && ~analysis_info.fit_xy_cross_correlation) || (fit_xy && calibration);
    
            % single frame pattern fitting
            curr_dx = analysis.stage_correction_x(max(acq.i_total-1,1));
            curr_dy = analysis.stage_correction_y(max(acq.i_total-1,1));
    
            % drift correction
            if analysis_info.fit_xy_cross_correlation && fit_xy && ~calibration
                [new_dx,new_dy] = get_drift(frame);
                delta_x = new_dx - curr_dx;
                delta_y = new_dy - curr_dy;
                for j=1:num_mol
                    analysis.molecules(j).params(1:2) = analysis.molecules(j).params(1:2) + [delta_x delta_y];
                    analysis.molecules(j).params(1:2) = analysis.molecules(j).params(1:2) + [delta_x delta_y];
                end
                curr_dx = new_dx;
                curr_dy = new_dy;
                if abs(delta_x)>0
                    1;
                end
            end
            switch analysis.analysis_mode
                case 'rotation'
                    [analysis_info,temp_molecules,total_int] = single_frame_analysis_core_2...
                        (handles,analysis_info,frame,acq.i_total,analysis.molecules,num_mol,...
                        fit_xy_single_molecule,calibration,max_dist,params_to_opt);
    %                     analysis.stage_correction_x(acq.i_total) = analysis.stage_correction_x(max(1,acq.i_total-1)) + corr_x;
    %                     analysis.stage_correction_y(acq.i_total) = analysis.stage_correction_y(max(1,acq.i_total-1)) + corr_y;
    
                    fields = get_fields_for_analysis_core_output();
                    for j=1:num_mol
                        for field = fields
                            switch field{1}
                                case 'ROI'
                                    analysis.molecules(j).(field{1})(acq.i_total,:) = temp_molecules(j).(field{1});
                                case 'params'
                                    analysis.molecules(j).(field{1}) = temp_molecules(j).(field{1});
                                otherwise
                                    analysis.molecules(j).(field{1})(acq.i_total) = temp_molecules(j).(field{1});
                            end
                        end
                    end
                    % calculate and show current defocus   
                    all_current_defocuses = get_data(analysis.molecules,num_mol,'defocus',acq.i_total,acq.i_total);
                    current_defocus = mean(all_current_defocuses);
                    handles.defocus_current.String = sprintf('%.3f',current_defocus);

%                             t1 = toc;

                    piezo_defocusing = analysis_info.piezo_defocusing;
                    piezo_z = correct_z(handles,analysis,acq.i_total,num_mol,current_defocus,calibration,piezo_defocusing);
%         disp(toc-t1);
% piezo_z =-1;
                    
                    if acq.i_total == 1
                        % it might not get data, so get it for first frame
                        % at least
                        piezo_z = display_piezo_position(handles);
                    else
                        if piezo_z == -1
                            piezo_z = analysis.piezo_z(acq.i_total - 1);
                        end
                    end
                    analysis.piezo_z(acq.i_total) = piezo_z;
                    analysis.stage_correction_x(acq.i_total) = curr_dx;
                    analysis.stage_correction_y(acq.i_total) = curr_dy;
                    analysis.total_int(acq.i_total) = total_int;
                case 'finding area'
                    single_frame_finding_area_core(handles,analysis_info,frame,handles.stage_settings,acq.i_total);
                case 'finding focus'
                    [focus_measure,scan_step] = single_frame_finding_focus_core(handles,handles.finding_focus_settings,analysis_info,analysis,frame,acq.i_total);
                    analysis.focus_measure(acq.i_total) = focus_measure;
                    if scan_step > 0
                        analysis.piezo_scan_results(scan_step) = focus_measure;
                    end
                case 'immobilization'
                    [total_num_mol,avg_closest_dist,total_int,all_positions,uncrowded_num_mol,uncrowded_positions] = ...
                        single_frame_immobilization_mode_core(frame,acq.i_total,handles.analysis_settings,analysis_info,analysis);
    
                    % all mol
                    analysis.total_num_mol_trace(acq.i_total) = total_num_mol;
                    analysis.avg_closest_dist_trace(acq.i_total) = avg_closest_dist;
                    analysis.all_positions_trace{acq.i_total} = all_positions;
    
                    %uncrowded
                    analysis.uncrowded_num_mol_trace(acq.i_total) = uncrowded_num_mol;
                    analysis.uncrowded_positions_trace{acq.i_total} = uncrowded_positions;
                    analysis.total_int(acq.i_total) = total_int;
                case 'TIRF ensemble'
                    [int_green,int_red,FRET] = single_frame_TIRF_ensemble_mode_core(analysis_info,analysis,frame);
                    analysis.trace_green(acq.i_total) = int_green;
                    analysis.trace_red(acq.i_total) = int_red;
                    analysis.trace_FRET(acq.i_total) = FRET;
            end

            % sorting
            curr_sort_type = acq.current_sorting_val;
            new_sort_type = handles.sort_type.Value;
            if analysis.num_mol>0 && (acq.i_total == 1 || curr_sort_type ~= new_sort_type)
                disp('sorting');
                acq.current_sorting_val = new_sort_type;
                analysis.molecules = sort_molecules(handles,analysis.molecules,analysis.num_mol);
                handles = initialize_molecule_list(handles, analysis.molecules);
            end

            %% plots
            if acq.i_total == 1
                initialize_all = 1;
            else
                initialize_all = 0;
            end
            if handles.plot_graphs.Value
%                 try
                    handles = plot_graphs(handles,1,initialize_all,analysis,0);
%                 catch e
%                 end
            end
        end

        %% update time and stuff
%         t_real_total = toc - t_start;

        [handles,acq] = delay_stuff(handles,acq);


        if acq.synthetic && ~acq.live_analysis
%             pause(0.001);
        end
        
%         pause(0.001);
        if ~mod(acq.i_total,acq.interval_frames)
            drawnow
            if acq.live_analysis && analysis.num_mol>0
                toggle_ROIs(handles,analysis.molecules,num_mol);
            end
        end

        acq.i_total = acq.i_total+1;
        acq.i_local = acq.i_local+1;

        %% update file        
        % now check if file is changing
%         num_in_each_file = 4085; % tif, binning 1
%         factor = (512/acq.dim_vid)^2;
%         num_in_each_file = 4085*factor; % tif, binning 1
        switch acq.binning
            case 1
                factor = 512/acq.dim_vid;
                num_in_each_file = 4085*factor; % tif, binning 1
            case 2
                factor = 256/acq.dim_vid;
                num_in_each_file = 16288*factor; % tif, binning 2
        end


%         num_in_each_file = 4095; % fits, binning 1
        if acq.spool && acq.i_local > num_in_each_file
            acq = update_spool_reading_file(acq);
        end
        

        t_end = toc;
%         fprintf('total frame time: %f\n',t_end-t_start);

    end

    if acq.spool
        % delete file from disk!
%         delete(acq.file_descriptor_tif);
        delete(acq.filename_spool_temp);

%         fclose(acq.file_descriptor_tif);

        
        fclose(acq.resave_file_descriptor);
        [file_metadata,file_num] = get_current_file_metadata(handles);
        f_read = fopen(file_metadata.full_name);
        handles.file_metadatas(file_num).rdt_file_descriptor = f_read;
    end
    
    if acq.live_analysis
        acq.analysis = analysis;

        switch analysis.analysis_mode
            case 'finding area'
                handles = apply_area_deltas(handles);
            case 'finding focus'
                results = analysis.piezo_scan_results;
                [max_value,max_ind] = max(results);
                choice_ind = max_ind - 1; % the results are actually shifted forward by one step, correct backwards.
                z_target = analysis_info.piezo_scan_positions(choice_ind);
                piezo_set_position(handles.piezo, z_target);
                display_piezo_position(handles);
        end

    end

    acq.abort = handles.stop_acquisition.Value;
    if acq.abort
        acq.real_vid_len = acq.i_total - 1;
    end

    abort_acquisition(1);
    handles.stop_acquisition.Value = 0;
    drawnow 
    










    