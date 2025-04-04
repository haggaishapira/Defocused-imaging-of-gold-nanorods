function handles = set_default_finding_focus_settings(handles)    
    

    settings.use_scan = 1; % 1\0
    settings.scan_radius = 5; % um
    settings.scan_step_size = 0.2;
    settings.intensity_threshold = 5000;
    settings.step_time_interval = 0.2; % sec
    
    handles.finding_focus_settings = settings;











