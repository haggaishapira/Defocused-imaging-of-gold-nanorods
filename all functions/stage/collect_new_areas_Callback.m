function collect_new_areas_Callback(hObject, eventdata, handles)


    stage_settings = handles.stage_settings;
    finding_focus_settings = handles.finding_focus_settings;

    num_areas = stage_settings.num_areas_to_collect;
    x_direction = stage_settings.collect_areas_x_direction;
    x_interval = stage_settings.x_interval;
    
    original_filename = handles.filename.String;
    original_duration_input_string = handles.duration_input.String;
    for i=1:num_areas
        if handles.stop_acquisition.Value
            return;
        end

        % change filename
        handles.filename.String = [original_filename '_' num2str(i)];

        % find focus
        % temporary change analysis mode, do acquisition, then return
        handles.analysis_mode_setting = 'finding focus';
        % set acquisition time to time required to scan
        full_range = finding_focus_settings.scan_radius * 2;
        num_steps = full_range / finding_focus_settings.scan_step_size + 1;
        time_required = num_steps * finding_focus_settings.step_time_interval;
        time_required = time_required + 1; % add 1 sec just in case
        handles.duration_input.String = num2str(time_required);
        
        handles = start_acquisition(handles,1);
        handles = delete_file(handles);

        % go back
        handles.analysis_mode_setting = 'rotation';
        handles.curr_position_search_method_setting = 'search when focused';

        handles.duration_input.String = original_duration_input_string;
        handles = start_acquisition(handles,1);

        if i < num_areas
            % move distance in chosen direction
            dx = x_interval * x_direction;
            dy = 0;
            handles = move_stage_delta(handles,dx,dy);
        end
    end
    handles.filename.String = original_filename;


    update_handles(handles.figure1, handles);









