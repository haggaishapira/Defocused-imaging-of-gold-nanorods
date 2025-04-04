function handles = move_stage_delta(handles,dx,dy)

    curr_x = str2num(handles.stage_x_current.String);
    curr_y = str2num(handles.stage_y_current.String);
    handles.stage_x_target.String = num2str(curr_x+dx);
    handles.stage_y_target.String = num2str(curr_y+dy);
    handles = apply_xy_target(handles);