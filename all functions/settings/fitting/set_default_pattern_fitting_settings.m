function handles = set_default_pattern_fitting_settings(handles)   
    
    settings.z = 0; % the molecule is in the middle of the film lets say. (Doesn't change much)    
    settings.NA = 1.45;
    settings.n0 = 1.52;
    settings.n = 1.33; % PVA    
    settings.n1 = 1.33;
    settings.d0 = 0;
    settings.d = 1e-3; % 20 nm film
    settings.d1 = 0;
    settings.lamem = 0.640;
    settings.mag = 96;
    settings.atf = 0;
    settings.ring = 0;
    settings.pixel = 16;
    settings.nn = 12;
    settings.block = 2; % in mm
    settings.defocus = -1.2;
    settings.res_theta = 10;
    settings.res_phi = 5;
    settings.num_smooth = 0;
    
    settings.min_defocus = -1.4;
    settings.max_defocus = 0;

    handles.pattern_fitting_settings = settings;





    