function handles = toggle_arrows(handles)

    visible = handles.toggle_arrows.Value;

    [molecules,num_mol] = get_current_molecules(handles);



    for i=1:num_mol
        molecules(i).arrow_main.Visible = visible;
        molecules(i).arrow_right.Visible = visible;
        molecules(i).arrow_left.Visible = visible;
    end

    pause(0.01);

    if visible
        handles.all_lines = make_lines_array(molecules,num_mol);
    end