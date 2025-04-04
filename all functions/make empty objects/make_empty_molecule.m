function molecule = make_empty_molecule(num,vid_len)

%     vid_len = handles.vid_len;
%      current_file = get_current_file(handles);
%     framerate = current_file.framerate;
%     molecule.t = (1:vid_len)/framerate;

%     molecule.ROI = zeros(4,len);
%     molecule.ROI = repmat(ROI',1,vid_len);
    molecule.num = num;
    molecule.str = sprintf('molecule %d',num);
%     molecule.str = sprintf('<HTML><FONT color="red">molecule %d</Font></html>',num);

    
    molecule.ROI = zeros(vid_len,4);
    molecule.ROI_handle = [];
    molecule.lst_sq_find = 0;
    molecule.lst_sq_video = zeros(vid_len,1);
%     molecule.lst_sq = lst_sq;
%     molecule.focus = ROI_to_focus(handles, ROI(3));
%     molecule.focus = focus * ones(vid_len,1);
    molecule.defocus = zeros(vid_len,1);
%     molecule.defocus_ind = zeros(vid_len,1,'uint8');
%     molecule.angle = zeros(len,1);
    
%     molecule.t = zeros(vid_len,1);
    molecule.y = zeros(vid_len,1);
    molecule.x = zeros(vid_len,1);

%     molecule.params = zeros(vid_len,5,'uint8');
%     molecule.params = zeros(vid_len,5);
    molecule.params = zeros(1,5);
    molecule.initial_position = zeros(1,2);
    molecule.initial_ROI = zeros(1,4);

    molecule.theta_half = zeros(vid_len,1,'int16');
    molecule.phi_half = zeros(vid_len,1,'int16');
    molecule.theta_whole = zeros(vid_len,1,'int16');
    molecule.phi_whole = zeros(vid_len,1,'int16');
    molecule.trace_theta_half = zeros(vid_len,1,'int16');
    molecule.trace_phi_half = zeros(vid_len,1,'int16');
    molecule.trace_theta_whole = zeros(vid_len,1,'int16');
    molecule.trace_phi_whole = zeros(vid_len,1,'int16');

    molecule.trace_phi_whole_rel_FH12 = zeros(vid_len,1,'int16');
    molecule.trace_phi_whole_around_0 = zeros(vid_len,1,'int16');

    molecule.int = zeros(vid_len,1,'int32');
    molecule.back = zeros(vid_len,1,'int32');

    molecule.d_phi = zeros(vid_len,1,'int16');
    molecule.d_theta = zeros(vid_len,1,'int16');

    molecule.free = zeros(vid_len,1,'int16');

    molecule.S2N = [];
    molecule.avg_int = [];
    
    % arrows
    molecule.arrow_main = [];
    molecule.arrow_right = [];
    molecule.arrow_left = [];
    molecule.arrow_main_initial = [];
    molecule.arrow_right_initial = [];
    molecule.arrow_left_initial = [];
%     molecule.arrow_ROI = [];

    %for sorting
    molecule.text_num = [];
%     molecule.average_stdev = [];

    molecule.dissociation_time = 0;
    molecule.dissociation_frame = 0;
  
    molecule.deviation_from_free_rotation = 0;
    molecule.preferred_phi = 0;
    molecule.pref_phi_rel = 0;
    molecule.span = 0;

    molecule.span_before_release = 0;
    molecule.d_phi_exponent_fitting_mu = 0;
    molecule.preferred_phi_after_release = 0;
    
    molecule.phi_dist_mu = 0;
    molecule.phi_dist_sigma = 0;

    molecule.FH12_position = 0;

    molecule.on_frames = [];
%     molecule.on_segments = []; % make this a struct
%     molecule.reactions = []; % make this a struct
    molecule.on_segments_gaussian_fittings = [];
%     molecule.on_segments_fuel_commands = [];

%     molecule.off_frames = [];
    molecule.on_trace = zeros(vid_len,1,'logical');

    % avg intensity
    molecule.int_by_angle = zeros(72,1);
%     molecule.int_by_angle = cell(72,1);
    molecule.int_by_angle_hist = [];

    molecule.stuck = 0;
    molecule.stuck_trace = [];

    molecule.stuck_correctly = 0;
    molecule.num_matches = 0;

    molecule.sorting_val = 0;

    molecule.molecule_of_interest = 0;

    % hmm
%     molecule.hmm_phi_traces = {};
%     molecule.hmm_state_traces = [];
%     molecule.hmm_t_traces = {};
    
    molecule.step_reactions = [];
    molecule.immobilization_reactions = [];
    molecule.release_reactions = [];

    molecule.dwells = [];
%     molecule.dwell_times = [];
%     molecule.dwell_start_times = [];
%     molecule.dwell_phis = [];











