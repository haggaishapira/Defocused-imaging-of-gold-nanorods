function [handles,analysis_info,analysis,accept] = initialize_analysis(handles,live_analysis)

    setappdata(0,'stop',0);
    delete(findall(gcf,'type','annotation'));
    delete(handles.ax_video.Children(1:end-1));

    analysis_settings = handles.analysis_settings;
%     acq.analysis_settings = analysis_settings;
    [file_metadata,file_num] = get_current_file_metadata(handles);
    vid_size = file_metadata.vid_size;
    vid_len = file_metadata.vid_len;

    analysis = make_empty_analysis();
    analysis.empty = 0;

    analysis.analysis_mode = handles.analysis_mode_setting;

    dim_vid = min(vid_size(1:2));
    analysis.dim_vid = dim_vid;
    analysis.vid_len = vid_len;

    analysis_info.framerate = str2num(handles.framerate.String);
    analysis.framerate = str2num(handles.framerate.String);
    analysis.t = (1:analysis.vid_len)/analysis.framerate;

    analysis_info.get_positions_method = handles.curr_position_search_method_setting;
    analysis_info.registered_positions = handles.registered_positions;

    general_settings = handles.general_settings;
    shift_x = general_settings.shift_x;
    shift_y = general_settings.shift_y;

    accept = 1;

    use_pre_acquired = analysis_settings.use_pre_acquired_first_frames;    

    % find first frames somehow
%     first_frames = get_first_frames(handles,live_analysis,use_pre_acquired,dim_vid);
    num_first_frames = min(handles.analysis_settings.num_first_frames,handles.vid_len);

    
    % should I get first frames?
    search_method = analysis_info.get_positions_method;
%     need_first = ismember(search_method,{'search when focused','search when defocused - preset defocus',...
%                                        'search when defocused - find common defocus','search when defocused - find defocus per molecule'});
    need_first = 1;

    analysis_info.piezo_defocusing = strcmp(search_method,'search when focused');

    if live_analysis 
        if strcmp(analysis.analysis_mode,'rotation') && need_first
            first_frames = acquire_first_frames_from_camera(handles,analysis_settings, handles.acq, use_pre_acquired);
        else
            first_frames = zeros(dim_vid,dim_vid,num_first_frames);
        end

        % record x,y,z
        analysis.x_coord = str2num(handles.stage_x_current.String);
        analysis.y_coord = str2num(handles.stage_y_current.String);
%         analysis.z_coord = str2num(handles.piezo_z_current.String); % do this after defocusing\calibration

    else
        file_metadata = handles.file_metadatas(handles.current_file_num);
        if ~isempty(file_metadata.first_frames) && use_pre_acquired
            first_frames = file_metadata.first_frames;
        else
            first_frames = zeros(dim_vid,dim_vid,num_first_frames);
            for i=1:num_first_frames
                frame = get_frame(handles,i,0);  
                frame = frame(1:dim_vid,1:dim_vid);
                first_frames(:,:,i) = frame;
            end
        end
    end



    first_frames = double(first_frames);
    analysis_info.first_frames = first_frames;
    analysis_info.avg_frame = sum(first_frames,3)/num_first_frames;
    analysis_info.focused_frame = analysis_info.avg_frame;
    analysis_info.frame1 = first_frames(:,:,1);
    handles.frame = analysis_info.avg_frame;


    % defocus tracking
%     search_method = analysis_info.get_positions_method;
%     if strcmp(search_method,'search when focused')

%     end

%     defocus_time_interval = analysis_settings.defocus_shift_tracking_time_interval;
%     defocus_interval_frames = round(defocus_time_interval*analysis.framerate);
%     defocus_interval_frames = max(defocus_interval_frames,1);
%     analysis_info.focus_interval_frames = min(focus_interval_frames,analysis_info.vid_len);
%     analysis_info.defocus_interval_frames = max(defocus_interval_frames,1);

%     stage_time_interval = analysis_settings.stage_shift_tracking_time_interval;
%     stage_interval_frames = round(stage_time_interval*analysis.framerate);
%     stage_interval_frames = max(stage_interval_frames,1);
%     analysis_info.stage_interval_frames = min(stage_interval_frames,analysis.vid_len);
%     analysis_info.stage_interval_frames = max(stage_interval_frames,10);

    framerate = analysis.framerate;
    analysis_info.fit_z_initial_frame_interval = round(analysis_settings.fit_z_initial_time_interval * framerate);
    analysis_info.fit_z_continuous_frame_interval = round(analysis_settings.fit_z_continuous_time_interval * framerate);
    analysis_info.fit_xy_initial_frame_interval = round(analysis_settings.fit_xy_initial_time_interval * framerate);
    analysis_info.fit_xy_continuous_frame_interval  = round(analysis_settings.fit_xy_continuous_time_interval * framerate);
    analysis_info.finish_calibration_frame = round(analysis_settings.initial_calibration_duration * framerate);
    analysis_info.finish_calibration_frame = max(analysis_info.finish_calibration_frame,1);

    analysis_info.original_mask = handles.original_ring_mask;

%     finished_position_time = 2;
%     finished_position_time = analysis_settings.time_to_find_position;
%     finished_position_time = 5;
%     analysis_info.finish_calibration_frame = round(analysis_settings.initial_calibration_duration*analysis_info.framerate);

%     analysis_info.ring_fitting = analysis_settings.ring_fitting;

%     analysis_info.interval_ring_fitting = 10;

%     framerate = analysis.framerate;
%     time_interval_ring_fitting = analysis_settings.defocus_shift_tracking_time_interval;
%     time_interval_ring_fitting = 10; % sec
%     analysis_info.interval_ring_fitting = round(time_interval_ring_fitting*framerate);


    analysis_info.num_frames_collapse = 10;
    analysis_info.collapse_frames = zeros(dim_vid,dim_vid,analysis_info.num_frames_collapse);
    analysis_info.collapse = zeros(dim_vid,dim_vid);

    % rings
    full_dim = 29;
    center = (full_dim+1)/2;
    analysis_info.rings = zeros(full_dim,full_dim,15);
    
    original_ring = handles.original_ring_mask;
%     figure
    for i=0:14
        ring_dim = i*2+1;
        ring = my_transform_fit_size_2(original_ring,25,ring_dim,25,ring_dim,0,0);
        analysis_info.rings(center-i:center+i,center-i:center+i,i+1) = ring;
%         final_ring = squeeze(analysis_info.rings(:,:,i+1));
%         imagesc(final_ring);
    end

%     analysis_info.max_pix_from_initial_position = analysis_settings.max_pix_from_initial_position;

    % general traces
    analysis.total_int = zeros(vid_len,1);
    analysis.stage_correction_x = zeros(vid_len,1);
    analysis.stage_correction_y = zeros(vid_len,1);
    analysis.diff_phase = zeros(vid_len,1);

    % piezo
    analysis.piezo_z = zeros(vid_len,1);

    % molecule distance stuff
    pixel_size = analysis_settings.pixel_size;
    min_intermolecular_distance = analysis_settings.min_intermolecular_distance;
    analysis_info.min_distance_pixels = round(min_intermolecular_distance/pixel_size); % for 60x objective and 1.6 magnification


    if strcmp(analysis.analysis_mode,'immobilization')
    % immobilization trace
        analysis.avg_closest_dist_trace = zeros(vid_len,1);
        analysis.total_num_mol_trace = zeros(vid_len,1);
        analysis.uncrowded_num_mol_trace = zeros(vid_len,1);
    end



    % borders
    borders.top = analysis_settings.dist_y_top;
    borders.left = analysis_settings.dist_x_left;
    borders.bottom = dim_vid - analysis_settings.dist_y_bottom;
    borders.right = dim_vid - analysis_settings.dist_x_right;

    % actually its rotated
%     borders.top = analysis_settings.dist_y_top;
%     borders.left = analysis_settings.dist_x_left;
%     borders.bottom = dim_vid - analysis_settings.dist_x_bottom;
%     borders.right = dim_vid - analysis_settings.dist_x_right;


    analysis_info.borders = borders;
    analysis_info.dim_vid = analysis.dim_vid;

    % current defocus to use
    current_defocus = analysis_settings.current_defocus;
    current_defocus_ind = defocus_to_defocus_ind(current_defocus);
    analysis_info.current_defocus_ind = current_defocus_ind;

    % desired_num_mol
    analysis_info.desired_num_mol = analysis_settings.desired_num_mol;

    analysis_info.patterns = handles.patterns;


    % stats first frame
%     first_t = 0;
%     first_t = str2num(handles.first_t.String);
    last_t = vid_len/analysis_info.framerate;
%     last_t = file_meta_data.duration

%     stats_min_frame = first_t*analysis_info.framerate;
%     handles.first_t.String = num2str(first_t);
    handles.first_t.String = num2str(0);
    handles.last_t.String = num2str(last_t);
    
    analysis_info.intensity_threshold = analysis_settings.intensity_threshold;


    % drift coroection
    analysis_info.fit_xy_cross_correlation = analysis_settings.fit_xy_cross_correlation;

    analysis_info.center_x = analysis_settings.center_x_definition;
    analysis_info.center_y = analysis_settings.center_y_definition;
    
    analysis_info.ref_ROI_rad = round(analysis_settings.ref_ROI_dim / 2);
%     analysis_info.max_drift = analysis_settings.max_drift;

    if ~live_analysis
        analysis_info.reference_frame = get_frame(handles,analysis_info.finish_calibration_frame,0);
    else
        analysis_info.reference_frame = analysis_info.avg_frame;
    end

    % TIRF ensemble
    analysis.trace_green = zeros(vid_len,1);
    analysis.trace_red = zeros(vid_len,1);
    analysis.trace_FRET = zeros(vid_len,1);

    analysis.TIRF_background_green = str2double(handles.TIRF_background_green_output.String);
    analysis.TIRF_background_red = str2double(handles.TIRF_background_red_output.String);

    analysis_info.subtract_background = handles.TIRF_subtract_background.Value;

    analysis_info.ax_video = handles.ax_video;


    % for stage drift tracking
    if analysis_info.fit_xy_cross_correlation
        center_x = analysis_info.center_x;
        center_y = analysis_info.center_y;
        ref_ROI_rad = analysis_info.ref_ROI_rad;
        
        ROI_drift = [center_x-ref_ROI_rad center_y-ref_ROI_rad ref_ROI_rad*2+1 ref_ROI_rad*2+1];
        analysis_info.ROI_drift = ROI_drift;
        drift_ROI_handle = drawrectangle(handles.ax_video,'Position',ROI_drift,'Color',[1 0 0],...
                            'FaceAlpha',0,'LineWidth',0.5,'MarkerSize',1);
        
        % choose if to accept ROIs
        opts.Interpreter = 'tex';
        opts.Default = 'Yes';
        answer = questdlg('accept drift ROI?', 'Choose if to accept ROI', 'Yes', 'No', opts);
        delete(drift_ROI_handle);
        if strcmp(answer,'No')
            accept = 0;
            return;
        end
    end
    analysis_info.current_dx = 0;
    analysis_info.current_dy = 0;

    switch analysis.analysis_mode
        case 'rotation'
            analysis = initialize_molecule_positions(analysis_settings,analysis_info,analysis);
            analysis.molecules = add_molecule_ROI_handles(handles, analysis.molecules, 1);
            if analysis_settings.ask_to_accept_ROI
                accept = question_accept_molecule_ROIs(handles, analysis.molecules, analysis.num_mol);
            else
                accept = 1;
            end
            if ~accept
                for i=1:analysis.num_mol
                    delete(analysis.molecules(i).ROI_handle);
                end
            else
                handles = set_molecule_selection(handles,[]);
            end
        case 'finding area'
            % initialize ROI square
            center_x = analysis_info.center_x;
            center_y = analysis_info.center_y;
            ref_ROI_rad = analysis_info.ref_ROI_rad;
            
            area_ROI = [center_x-ref_ROI_rad center_y-ref_ROI_rad ref_ROI_rad*2+1 ref_ROI_rad*2+1];
            handles.area_ROI_handle = drawrectangle(handles.ax_video,'Position',area_ROI,'Color',[0 1 0],...
                                'FaceAlpha',0,'LineWidth',0.5,'MarkerSize',1);

            % show also ROIs
            handles = toggle_registered_positions_ROIs(handles);

        case 'finding focus'

            analysis.focus_measure = zeros(vid_len,1);
            
            borders = analysis_info.borders;
            use_radius = analysis_settings.position_filter_by_radius;
            max_radius = analysis_settings.max_radius;
            dim_vid = analysis_info.dim_vid;
            center_x = analysis_settings.center_x_definition;
            center_y = analysis_settings.center_y_definition;
        
            analysis_info.disk_center_mask = ones(512,512,'logical');
            for i=1:512
                for j=1:512
                    dx = j - center_x;
                    dy = i - center_y;
                    if abs(dx) > max_radius || abs(dy) > max_radius
                        analysis_info.disk_center_mask(i,j) = 0;
                    end
                end
            end
            
            finding_focus_settings = handles.finding_focus_settings;
            if finding_focus_settings.use_scan
                scan_radius = finding_focus_settings.scan_radius; % um
                scan_step_size = finding_focus_settings.scan_step_size; 

                curr_z = handles.piezo.qPOS('1');
                min_z = curr_z - scan_radius;
                max_z = curr_z + scan_radius;
                scan_range = scan_radius * 2;
                num_steps = round(scan_range / scan_step_size) + 1;
                analysis_info.num_steps = num_steps; 
                analysis_info.piezo_scan_positions = min_z:scan_step_size:max_z;

%                 disp(analysis_info.piezo_scan_positions);

                time_interval = finding_focus_settings.step_time_interval; % sec
                frame_interval = round(time_interval * analysis_info.framerate);
                analysis_info.finding_focus_frame_interval = frame_interval;
                analysis.piezo_scan_results = zeros(num_steps,1);
                
                % check if length is insufficient
                scan_duration = num_steps * time_interval;
                accept = scan_duration <= file_metadata.duration;
                if ~accept
%                     analysis_info.use_scan = 0;
                    msgbox('video length too short for scan duration. not scanning');
                end

                % go to start immediatly
                desired_pos = analysis_info.piezo_scan_positions(1);
%                 fprintf('desired pos: %f\n',desired_pos);
                piezo_set_position(handles.piezo,desired_pos);
                display_piezo_position(handles);
            end
    end

    analysis_info.min_theta_ind = round(analysis_settings.min_theta/10 + 1);
    
    % transform
    analysis_info.transform = get_transform_arr(analysis.num_mol);

%     analysis_info.max_defocus_ind = round(handles.fitting_settings.max_defocus * -10);
        analysis_info.max_defocus_ind = 13;

    handles.analysis_info = analysis_info;


    







