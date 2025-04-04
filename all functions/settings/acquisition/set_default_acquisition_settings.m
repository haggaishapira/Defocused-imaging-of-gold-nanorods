function handles = set_default_acquisition_settings(handles)    

    settings.synthetic = 0; 
    settings.exposure_time = 0.001; %secs
    settings.gain = 100;
    settings.binning = 1;
    settings.kinetic_cycle_time = 0.08;
    settings.time_interval_pause = 0.5; %secs
    settings.frame_transfer = 0; % no dead time - max 1/30ms framerate for full screen

    settings.flip_horizontally = 0;
    settings.rotate_clockwise = 0;
    settings.rotate_counterclockwise = 0;

    handles.acquisition_settings = settings;

