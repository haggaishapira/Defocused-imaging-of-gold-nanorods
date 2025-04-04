function piezo_z = correct_z(handles,analysis,i,num_mol,current_defocus,calibration,piezo_defocusing)

    settings = handles.piezo_settings;
%     piezo_defocusing = settings.piezo_defocusing;

    use_correction = handles.apply_z_correction.Value;
    piezo_z = -1; % default

    target_defocus = str2num(handles.defocus_target.String);
    framerate = analysis.framerate;

    % just initial defocusing
    if i == 1 
        if piezo_defocusing
            % just jump by 1 um down or something
            piezo_z = display_piezo_position(handles);   
            desired_pos = piezo_z + target_defocus;
            piezo_set_position(handles.piezo,desired_pos);
%             display_piezo_position(handles);           
        end
        return;
    end

    % continuous correction
    if use_correction && num_mol>0
        time_interval = settings.correction_time_interval;
        calibration_time_interval = settings.calibration_time_interval;
        frame_interval = round(time_interval*framerate);
        calibration_frame_interval = round(calibration_time_interval*framerate);

        min_t = 3;
        min_frame = round(min_t*framerate);
        if calibration
            correct_now = ~mod(i,calibration_frame_interval) && i>= min_frame;
        else
            correct_now = ~mod(i,frame_interval);
        end
        if ~correct_now 
            return;
        end
    else
        return;
    end


    piezo_z = display_piezo_position(handles);   

    max_step_size = settings.correction_max_step_size;
    min_step_size = 0.03;
    delta = target_defocus - current_defocus;
%             fprintf('delta is %.3f\n', delta);
    abs_delta = abs(delta);
    if abs_delta > max_step_size
        delta = max_step_size * sign(delta);
    end
    if abs_delta > min_step_size
        desired_pos = piezo_z + delta;
%                 fprintf('correcting z by %.3f\n', delta);


%         fprintf('desired position %.3f\n', desired_pos);
        piezo_set_position(handles.piezo,desired_pos);

    end
%     display_piezo_position(handles);           







