function handles = measure_existing_areas(handles)

    stage_settings = handles.stage_settings;

    % get current batch
    file_nums = get_all_file_nums_in_selected_batch(handles);

    num_areas = length(file_nums);

    % remember stuff
    original_duration_input_string = handles.duration_input.String;
    original_filename = handles.filename.String;
    original_cycle_time = handles.acquisition_settings.kinetic_cycle_time;

%     original_duration_input_string = handles.duration_input.String;

    num_cycles = stage_settings.measurement_cycles;

    
    accumulated_error_x = 0;
    accumulated_error_y = 0;

    
    % trigger microfluidics
    cycle_to_trigger = 2;
    % trigger here
    trigger_microfluidics = handles.trigger_microfluidics.Value;
    handles.trigger_microfluidics.Value = 0;

    for j=1:num_cycles
        if trigger_microfluidics && j == cycle_to_trigger
            response_ok = send_message_and_test_response(handles.microfluidics_connection,'1');
        end

        for i=1:num_areas
            if handles.stop_acquisition.Value || getappdata(0,'stop_measuring')
                disp('abort measurements');
                return;
            end
    
            % change filename
            handles.filename.String = [original_filename '_c' num2str(j) '_a' num2str(i)];
    
            file_num = file_nums(i);
            handles = select_file(handles,file_num,1);
    %         handles.file_list.Value = file_num;
    
            analysis = handles.analyses(file_num);
            % go to area
            target_x = analysis.x_coord;
            target_y = analysis.y_coord;
            target_z = analysis.z_coord;
    
%             factor = 5;
%             threshold = 5;
%             if accumulated_error_x > threshold
%                 target_x = target_x + accumulated_error_x/factor;
%             end
%             if accumulated_error_y > threshold
%                 target_y = target_y + accumulated_error_y/factor;
%             end


            handles.stage_x_target.String = target_x;
            handles.stage_y_target.String = target_y;
            handles = apply_xy_target(handles);
    
            keep_curr_z = 1;

            if i == 1    
                if keep_curr_z
                    target_z = handles.piezo_z_current.String;
                end
            end

            if i > 1
                target_z = target_z + global_delta_z;
            end

            handles.piezo_z_target.String = target_z;
            handles = apply_z_target(handles);

            
    
            % memory z could be inaccurate defocus position. 
            % so for first apply area find focus algorithm, then defocus according to current settings. 
            % after rotation measurement, calculate delta relative to memory z.
            % for remaining areas only use delta with memory z.
            always_scan_focus = stage_settings.always_scan_focus;
%             always_scan_focus = 1;
            scan_focus = always_scan_focus || i == 1;
            if scan_focus
                % find focus, and apply defocus according to settings
                % temporary change analysis mode, do acquisition, then return
                handles.analysis_mode_setting = 'finding focus';
                % set acquisition time to time required to scan
                finding_focus_settings = handles.finding_focus_settings;
                full_range = finding_focus_settings.scan_radius * 2;
                num_steps = full_range / finding_focus_settings.scan_step_size + 1;
                time_required = num_steps * finding_focus_settings.step_time_interval;
                time_required = time_required + 1; % add 1 sec just in case
                handles.duration_input.String = num2str(time_required);
                
                handles.acquisition_settings.kinetic_cycle_time = 0.08;
                handles = start_acquisition(handles,1);
                handles = delete_file(handles);
    
                if handles.stop_acquisition.Value || getappdata(0,'stop_measuring')
                    disp('abort measurements');
                    return;
                end

                % apply defocus 
                curr_z = str2num(handles.piezo_z_current.String); % focus
                target_z = curr_z + str2num(handles.defocus_target.String); % defocus is negative
                handles.piezo_z_target.String = num2str(target_z);
                handles = apply_z_target(handles);
    
                % update current z: 
                % do this only after optimization during rotation measurement
            end
    
            % find area
            handles.analysis_mode_setting = 'finding area';
            handles.duration_input.String = 1;
            handles.acquisition_settings.kinetic_cycle_time = 0.08;
            handles = start_acquisition(handles,1);
            handles = delete_file(handles);
    
            if handles.stop_acquisition.Value || getappdata(0,'stop_measuring')
                disp('abort measurements');
                return;
            end

            % move stage according to deltas
%             stage_settings = handles.stage_settings;
%             delta_x = str2num(handles.area_delta_x.String);
%             delta_y = str2num(handles.area_delta_y.String);
%             if abs(delta_x) > stage_settings.error_threshold || abs(delta_y) > stage_settings.error_threshold
%                 % move +(x+100) then -100
%                 handles = move_stage_delta(handles,delta_x+100,delta_y);
%                 handles = move_stage_delta(handles,-100,delta_y);
%             end
%             accumulated_error_x = str2num(handles.area_delta_x.String);
%             accumulated_error_y = str2num(handles.area_delta_y.String);

            % go back
            handles.duration_input.String = original_duration_input_string;
            handles.analysis_mode_setting = 'rotation';
    %         handles.duration_input.String = original_duration_input_string;
    
            % registered positions
            handles.curr_position_search_method_setting = 'registered positions';
    
            % measure rotation
            handles.acquisition_settings.kinetic_cycle_time = original_cycle_time;
            handles = start_acquisition(handles,1);
    
            % now update global z
            curr_z = str2num(handles.piezo_z_current.String); % defocus
            global_delta_z = curr_z - analysis.z_coord;
    
            % delete file in end
%             handles = delete_file(handles);

        end
    end

    handles.filename.String = original_filename;










