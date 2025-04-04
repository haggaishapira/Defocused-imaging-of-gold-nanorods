function handles = toggle_reference_state_arrows(handles)

    visible = handles.toggle_reference_state_arrows.Value;

    [molecules,num_mol] = get_current_molecules(handles);

    for i=1:num_mol
        molecules(i).arrow_main_reference.Visible = visible;
        molecules(i).arrow_right_reference.Visible = visible;
        molecules(i).arrow_left_reference.Visible = visible;
    end

    pause(0.01);

    if visible
        handles.all_lines_reference = make_lines_array_reference(molecules,num_mol);
    end

    update_handles(handles.figure1, handles);
