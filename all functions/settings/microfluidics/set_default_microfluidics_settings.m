function handles = set_default_microfluidics_settings(handles)   
    
    settings.load_sequence_on_trigger = 1;
    settings.overwrite_measurement_time = 1;
    settings.start_time = 0; % sec

    handles.microfluidics_settings = settings;





    