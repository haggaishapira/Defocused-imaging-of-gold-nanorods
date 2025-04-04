function handles = set_default_stage_settings(handles)    
    
    settings.step_size = 1; % um

    settings.num_areas_to_collect = 1;
    settings.collect_areas_x_direction = 1; % right
    settings.x_interval = 100; % um

    % correct stage during find area
    settings.use_stage_correction = 0;
    settings.error_threshold = 1; %um
%     settings.correction_time_interval = 0.5; % sec

    % focus scanning
    settings.always_scan_focus = 0; %um

    settings.measurement_cycles = 1;

    settings.reaction_name_step = 1;
    settings.scan_vid_duration = 30;

    handles.stage_settings = settings;











