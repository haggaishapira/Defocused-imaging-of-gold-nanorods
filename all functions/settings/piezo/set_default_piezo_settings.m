function handles = set_default_piezo_settings(handles)   
    
%     settings.min_z = 0;
%     settings.max_z = 100;
    settings.default_z = 50;
    settings.step_size = 0.5;

    settings.correction_time_interval = 10; %sec
    settings.correction_max_step_size = 0.2; %um
    settings.correction_min_step_size = 0.03; %um

    settings.calibration_time_interval = 0.5; %sec
    settings.piezo_defocusing = 1;

    handles.piezo_settings = settings;





    