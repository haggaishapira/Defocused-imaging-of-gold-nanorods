function handles = set_default_analysis_settings(handles)    
    
    settings.desired_num_mol = 1;
    settings.num_first_frames = 10;
    settings.min_theta = 50;    
    settings.dist_x_left = 60;
    settings.dist_x_right = 60;
    settings.dist_y_top = 60;
    settings.dist_y_bottom = 60;
    settings.position_filter_by_radius = 1;
    settings.center_x_definition = 230;
    settings.center_y_definition = 240;
    settings.max_radius = 180;
    settings.initial_calibration_duration = 8; % sec
    settings.fit_z_initial = 1;
    settings.fit_z_initial_time_interval = 0.5;
    settings.fit_z_continuous = 1;
    settings.fit_z_continuous_time_interval = 10;

    settings.fit_xy_cross_correlation = 0;
    settings.fit_xy_initial = 1;
    settings.fit_xy_initial_time_interval = 0.5;
    settings.fit_xy_continuous = 1;
    settings.fit_xy_continuous_time_interval = 10;
    settings.ask_to_accept_ROI = 0;
    settings.use_pre_acquired_first_frames = 1;

    settings.min_intermolecular_distance = 3.5; % um
    settings.pixel_size = 0.166; % um
    settings.max_pix_from_initial_position = 5; 
    settings.max_pix_from_previous_position = 2; 
    settings.current_defocus = -1; % um
    settings.intensity_threshold = 3000; 

    settings.ref_ROI_dim = 300;
%     settings.max_drift = 20;

    settings.prescan_focus = 0;

    settings.use_registered_xy_shift = 0;


    handles.analysis_settings = settings;









