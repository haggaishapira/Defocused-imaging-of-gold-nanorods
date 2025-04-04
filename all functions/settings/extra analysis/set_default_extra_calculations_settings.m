function handles = set_default_extra_calculations_settings(handles)    
    
    settings.release_d_phi_threshold = 50;
    settings.release_min_t = 0;

    settings.immobilization_d_phi_threshold = 50;
    settings.immobilization_min_window_time = 200;

    settings.assume_on_initially = 0;
    settings.use_first_on_state_as_reference = 1;
    settings.use_registered_angles = 0;

    settings.stuck_max_range = 60;
    settings.stuck_max_sigma = 10;

    settings.immobilization_reaction = 0;
    settings.fuel_state = 0;

    settings.current_FH_angle = 0;

    settings.disable_FH12_positions = 0;

    settings.calc_hmm = 0;
    settings.hmm_num_states = 2;
    settings.hmm_smooth_trace = 1;
    settings.hmm_smooth_window = 5;
    settings.hmm_crop_trace = 1;
    settings.hmm_crop_interval = 5;
    settings.analyze_steps_individually = 1;

    % dwell times
    settings.max_range = 30;

    % 1 - F AF, 2 - walking, 
    settings.sequence_analysis_method = 2;

    % walking and F AF analysis
    settings.min_step_size = 10;
    settings.max_step_size = 70;

    settings.min_relative_step_time = -100;
    settings.max_relative_step_time = inf;

    settings.clockwise = 1;
    settings.anti_clockwise = 1;

    settings.AF_to_show = 0;

    handles.extra_calculations_settings = settings;









