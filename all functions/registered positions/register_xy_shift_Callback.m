function register_xy_shift_Callback(hObject, eventdata, handles)

    molecule = get_curr_mol_non_selected(handles);
    x_shift = molecule.x - molecule.x(33);
    y_shift = molecule.y - molecule.y(33);
    handles.registered_x_shift = x_shift;
    handles.registered_y_shift = y_shift;

    msgbox(sprintf('registered xy shift for molecule %d',molecule.num));

    update_handles(handles.figure1, handles);

