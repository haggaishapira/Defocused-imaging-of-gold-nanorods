function handles = apply_z_target(handles)

    desired_pos = str2num(handles.piezo_z_target.String);

    desired_pos = min(desired_pos,100);
    desired_pos = max(desired_pos,0);

    piezo = handles.piezo;
    piezo_set_position(piezo,desired_pos);

    display_piezo_position(handles);
