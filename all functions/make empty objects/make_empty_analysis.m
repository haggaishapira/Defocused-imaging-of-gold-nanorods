function analysis = make_empty_analysis()

    analysis.empty = 1;

    analysis.analysis_mode = 'no analysis';
    analysis.molecules = [];
    analysis.num_mol = 0;
    analysis.framerate = 0;
    analysis.vid_len = 0;
    analysis.dim_vid = 0;
    analysis.t = [];

    
    analysis.stage_correction_x = [];
    analysis.stage_correction_y = [];
    analysis.diff_phase = [];

    analysis.total_int = [] ;
    analysis.distances = [];

    analysis.piezo_z = [];

    % immobilization mode
    % all mol
    analysis.total_num_mol_trace = [];
    analysis.all_positions_trace = [];
    analysis.avg_closest_dist_trace = [];
    analysis.ints_trace = [];
    analysis.distance_matrix_trace = [];

    % uncrowded mol
    analysis.uncrowded_num_mol_trace = [];
    analysis.uncrowded_positions_trace  = [];

    % fittings
    analysis.fuel_fittings = [];
    analysis.anti_fuel_fittings = [];
    analysis.fitting_d_phi = [];
    
    analysis.piezo_z = [];

    % TIRF ensemble
    analysis.trace_green = [];
    analysis.trace_red = [];
    analysis.trace_FRET = [];

    analysis.TIRF_background_green = 0;
    analysis.TIRF_background_red = 0;

    % finding focus
    analysis.focus_measure = [];
    analysis.piezo_scan_results = [];

    % absolute coordinates
    analysis.x_coord = 0; % stage x
    analysis.y_coord = 0; % stage y
    analysis.z_coord = 0; % piezo z







    
