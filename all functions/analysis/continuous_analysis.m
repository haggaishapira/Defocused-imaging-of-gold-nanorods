function analysis = continuous_analysis(handles,analysis_info,analysis)

%     analysis_info = handles.analysis_info;
    vid_len = analysis.vid_len;
    num_mol = analysis.num_mol;
%     molecules = analysis.molecules;
    analysis_settings = handles.analysis_settings;

    tic
    wait_bar = waitbar(0,sprintf('analyzing %d molecules.\nframe %d/%d', num_mol, 0, vid_len));
    for i=1:vid_len

%         t_start = 85840;
%         t_end = 24000;
%         t_end = 1000;

%         if i < t_start*analysis.framerate
%             continue;
%         end
%         if i > t_end*analysis.framerate
%             break;
%         end


%         t1 = toc;
        
        frame_temp = get_frame(handles,i,0);
        if max(frame_temp(:)) > 2000
            frame = frame_temp;
        else
            1;
        end


%         analysis_info.collapse = frame;
        use_registered_xy_shift = analysis_settings.use_registered_xy_shift;

        if i < analysis_info.finish_calibration_frame
            fit_z = analysis_settings.fit_z_initial && (i == 1 || ~mod(i,analysis_info.fit_z_initial_frame_interval));
            fit_xy = analysis_settings.fit_xy_initial && (i == 1 || ~mod(i,analysis_info.fit_xy_initial_frame_interval));
            calibration = 1;
            max_dist = analysis_settings.max_pix_from_initial_position;
        else
            fit_z = analysis_settings.fit_z_continuous && (i == 1 || ~mod(i,analysis_info.fit_z_continuous_frame_interval));
            fit_xy = ~use_registered_xy_shift && analysis_settings.fit_xy_continuous && (i == 1 || ~mod(i,analysis_info.fit_xy_continuous_frame_interval));
            calibration = 0;
            max_dist = analysis_settings.max_pix_from_previous_position;
        end
        
    %     fit_xy = fit_xy && ~analysis_info.fit_xy_cross_correlation;
        
        if fit_z
            params_to_opt = 3:5;
        else
            params_to_opt = 4:5;
        end

%         x_shift = handles.registered_x_shift(i);
%         y_shift = handles.registered_y_shift(i);
        x_shift = 0;
        y_shift = 0;
        finish_calibration_frame = analysis_info.finish_calibration_frame;
        if use_registered_xy_shift && i>=finish_calibration_frame
            for j=1:num_mol
                analysis.molecules(j).params(1) = analysis.molecules(j).x(finish_calibration_frame-1) + x_shift;
                analysis.molecules(j).params(2) = analysis.molecules(j).y(finish_calibration_frame-1) + y_shift;
            end
        end

        fit_xy_single_molecule = (fit_xy && ~analysis_info.fit_xy_cross_correlation) || (fit_xy && calibration);

        % single frame pattern fitting
        curr_dx = analysis.stage_correction_x(max(i-1,1));
        curr_dy = analysis.stage_correction_y(max(i-1,1));
        curr_diff_phase = analysis.diff_phase(max(i-1,1));

        % drift correction
        if analysis_info.fit_xy_cross_correlation && fit_xy && ~calibration
            ROI_drift = analysis_info.ROI_drift;
            ref_frame = get_frame(handles,1,0);
            ref_frame_selected_area = get_integer_pixel_ROI_image(ref_frame,ROI_drift);
            new_frame_selected_area = get_integer_pixel_ROI_image(frame,ROI_drift);
            [new_dx,new_dy,new_diff_phase] = get_drift(ref_frame_selected_area,new_frame_selected_area);
            new_dx = -new_dx;
            new_dy = -new_dy;

%             delta_x = new_dx - curr_dx;
%             delta_y = new_dy - curr_dy;
%             delta_x = -delta_x;
%             delta_y = -delta_y;
%             delta_x = round(delta_x);
%             delta_y = round(delta_y);

%             delta_x = round(delta_x);
%             delta_y = round(delta_y);
            for j=1:num_mol
%                 analysis.molecules(j).params(1:2) = analysis.molecules(j).params(1:2) + [delta_x delta_y];
%                 analysis.molecules(j).params(1:2) = round(analysis.molecules(j).initial_position + [new_dx new_dy]);

%                 analysis.molecules(j).x(i) = analysis.molecules(j).x(max(i-1,1)) + delta_x;
%                 analysis.molecules(j).x(i) = analysis.molecules(j).y(max(i-1,1)) + delta_y;
            end
            curr_dx = new_dx;
            curr_dy = new_dy;
            curr_diff_phase = new_diff_phase;
%             if abs(delta_x)>0
%                 1;
%             end
            % correct the frame!!!
%             buf2ft = frame;
%             [nr,nc]=size(buf2ft);
%             Nc = ifftshift(-fix(nc/2):ceil(nc/2)-1);
%             Nr = ifftshift(-fix(nr/2):ceil(nr/2)-1);
%             [Nc,Nr] = meshgrid(Nc,Nr);
%             Greg = buf2ft.*exp(1i*2*pi*(-row_shift*Nr/nr-col_shift*Nc/nc));
%             Greg = Greg*exp(1i*diffphase);
%             corrected_frame = Greg;
        end

        [analysis_info,temp_molecules,tot_int] = single_frame_analysis_core_2(handles,analysis_info,frame,i,analysis.molecules,...
                                                                num_mol,fit_xy_single_molecule,calibration,max_dist,params_to_opt);

        analysis.total_int(i) = tot_int;
%         analysis.stage_correction_x(i) = analysis.stage_correction_x(max(1,i-1)) + curr_dx;
%         analysis.stage_correction_y(i) = analysis.stage_correction_y(max(1,i-1)) + curr_dy;
        analysis.stage_correction_x(i) = curr_dx;
        analysis.stage_correction_y(i) = curr_dy;
        analysis.diff_phase(i) = curr_diff_phase;

        fields = get_fields_for_analysis_core_output();
        for j=1:num_mol
            for field = fields
                switch field{1}
                    case 'ROI'
                        analysis.molecules(j).(field{1})(i,:) = temp_molecules(j).(field{1});
                    case 'params'
                        analysis.molecules(j).(field{1}) = temp_molecules(j).(field{1});
                    otherwise
                        analysis.molecules(j).(field{1})(i) = temp_molecules(j).(field{1});
                end
            end
        end

%         if mod(i,1000) == 0
%             figure
%             plot(analysis.stage_correction_x(1:i));
%             hold on
%             plot(analysis.stage_correction_y(1:i));
%             
%             figure
%             plot(analysis.molecules(1).x(1:i));
%             hold on
%             plot(analysis.molecules(1).y(1:i));
%             
%             1
%         end

        if ~mod(i,100)
            waitbar(i/vid_len,wait_bar,sprintf('analyzing %d molecules.\nframe %d/%d', num_mol, i, vid_len));
%             fprintf('frame #: %d\n', i);
%             disp(toc-t1);
%             toc
        end
%             fprintf('total time: %d\n',toc-t1);

        if handles.plot_graphs.Value && ~mod(i,1000)
            handles.frame = frame;
            show_frame(handles,frame);
            handles = set_analysis(handles,handles.current_file_num,analysis,0);
            curr_t = i/analysis.framerate;
            handles.last_t.String = num2str(curr_t);
            set(handles.slider_frames,'Value',i);
            display_frame_and_time(handles,i,analysis.framerate);
            handles = plot_graphs(handles,0,1,analysis,0);
        end

    end
    waitbar(vid_len,wait_bar,sprintf('analyzing %d molecules.\nframe %d/%d', num_mol, vid_len, vid_len));
    close(wait_bar);           










