function handles = set_default_filter_settings(handles)    
    
    settings.min_stuck = 1;
    settings.max_stuck = 1;

    settings.min_molecule_of_interest = 0;
    settings.max_molecule_of_interest = 1;

    settings.min_int = -inf;
    settings.max_int = inf;

    settings.min_mu = -inf;
    settings.max_mu = inf;

    settings.min_sigma = -inf;
    settings.max_sigma = inf;

    % settings.min_num_matches = 0;
    % settings.max_num_matches = inf;

    settings.min_responds_to_fuel = 0;
    settings.max_responds_to_fuel = 1;

    settings.min_stuck_correctly = 0;
    settings.max_stuck_correctly = 1;


    handles.filter_settings = settings;











