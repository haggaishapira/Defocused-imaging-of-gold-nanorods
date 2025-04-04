function handles = set_default_export_settings(handles)    
    
    settings.export_raw_video = 0;
    settings.export_analysis_video = 0;
    settings.export_raw_ROI = 0;
    settings.export_analysis_ROI = 0;
    settings.export_trace_sm = 0;
    settings.export_trace_ens = 0;
    settings.export_polar_hist = 0;
    settings.export_linear_hist = 0;
    settings.export_fitting = 0;
    settings.export_3d = 0;

    settings.mode = 2;

    handles.export_settings = settings;
