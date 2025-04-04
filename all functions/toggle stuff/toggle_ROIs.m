function toggle_ROIs(handles,molecules,num_mol)

    squares_on = handles.toggle_ROIs.Value;
    for i=1:num_mol
        if squares_on
            molecules(i).ROI_handle.Visible = 'on';
        else
            molecules(i).ROI_handle.Visible = 'off';
        end
    end
    