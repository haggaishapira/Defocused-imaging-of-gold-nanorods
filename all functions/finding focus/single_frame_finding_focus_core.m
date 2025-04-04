function [focus_measure,scan_step] = single_frame_finding_focus_core(handles,finding_focus_settings,analysis_info,analysis,frame,frame_num)

    % find points, separate by distance. then count them.
%     [positions,ints,num_mol] = find_positions_when_focused(analysis_settings,analysis_info,frame);
%     focus_measure = num_mol;

    % number of pixels above threshold
    settings = finding_focus_settings;
    intensity_threshold = settings.intensity_threshold;
%     focus_measure = length(find(frame(:)>threshold));

    circle_mask = analysis_info.disk_center_mask;
    finding_focus_frame_interval = analysis_info.finding_focus_frame_interval;
    scan_step = round(frame_num/finding_focus_frame_interval);
    scan_now = finding_focus_settings.use_scan && ~mod(frame_num,finding_focus_frame_interval) && scan_step <= analysis_info.num_steps;
    if ~scan_now
        scan_step = -1;
    end

    % scan for finding focus position in live analysis with piezo device
    if scan_now
        desired_pos = analysis_info.piezo_scan_positions(scan_step);
%         fprintf('desired pos: %f\n',desired_pos);
        piezo_set_position(handles.piezo,desired_pos);
        display_piezo_position(handles);
%         focus_measure = calculate_focus_measure(frame,circle_mask,intensity_threshold);
%         analysis_info.piezo_scan_results(scan_step) = focus_measure;

%         [max_value,max_ind] = max(results);
%         z_target = scan_positions(max_ind);
%         piezo_set_position(z_target);
%         focus_measure = max_value;
    end

    focus_measure = calculate_focus_measure(frame,circle_mask,intensity_threshold);













