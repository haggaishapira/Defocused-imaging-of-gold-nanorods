function handles = single_frame_finding_area_core(handles,analysis_info,frame,stage_settings,frame_num)

    area_reference = handles.area_reference;

    center_x = analysis_info.center_x;
    center_y = analysis_info.center_y;
    ref_ROI_rad = analysis_info.ref_ROI_rad;
    area_ROI = [center_x-ref_ROI_rad center_y-ref_ROI_rad ref_ROI_rad*2+1 ref_ROI_rad*2+1];
    area_current = get_integer_pixel_ROI_image(frame,area_ROI);

    [delta_x,delta_y,new_diff_phase,error] = get_drift(area_reference,area_current);

    delta_x = -delta_x;
    delta_y = -delta_y;

%     disp(delta_x);
%     disp(delta_y);

    % put ROI rectangle in delta position
    handles.area_error_output.String = sprintf('%.2f',error);
    handles.area_delta_x.String = sprintf('%.2f',delta_x);
    handles.area_delta_y.String = sprintf('%.2f',delta_y);

%     pos = handles.area_ROI_handle.Position;
    pos = area_ROI;
    new_x = pos(1) + delta_x;
    new_y = pos(2) + delta_y;

    if new_x<1
        new_x = 1;
    end
    if new_y<1
        new_y = 1;
    end
    if new_x + pos(3) - 1 > 512
        new_x = 512 - pos(3) + 1;
    end
    if new_y + pos(4) - 1 > 512
        new_y = 512 - pos(4) + 1;
    end
    
    new_pos = [new_x new_y pos(3:4)];
    new_pos = round(new_pos);

    handles.area_ROI_handle.Position = new_pos;

    % also change single molecule ROIs accordingly
%     new_pos
    ROIs = handles.registered_positions_ROIs;
    ROI_handles = handles.registered_positions_ROI_handles;
    num_mol = size(ROIs,1);
    for i=1:num_mol
        original_ROI = ROIs(i,:);
        ROI_handle = ROI_handles(i);
        modified_ROI = original_ROI;
        modified_ROI(1:2) = modified_ROI(1:2) + [delta_x delta_y];
        ROI_handle.Position = modified_ROI;
    end

    lower_threshold = 0.15;
    higher_threshold = 0.25;

    % color red above thres
    
    if error<lower_threshold
        col = [0 1 0];
    else
        if error>higher_threshold
            col = [1 0 0];
        else
            pos = (error - lower_threshold) / (higher_threshold - lower_threshold);
            col = [0 1 0] + pos * [1 -1 0];
        end
    end

    handles.area_ROI_handle.Color = col;


    % NEW - correct area using stage
    if stage_settings.use_stage_correction && frame_num == 20
        connected = strcmp(handles.stage_connected_output.String,'Connected');
        if connected
%             disp('deltas');
%             disp(delta_x);
%             disp(delta_y);
            if abs(delta_x) > stage_settings.error_threshold || abs(delta_y) > stage_settings.error_threshold
                handles = move_stage_delta(handles,delta_x,delta_y);
                disp('corrected area using stage');
%                 pause(0.5);
            end
        end
    end













