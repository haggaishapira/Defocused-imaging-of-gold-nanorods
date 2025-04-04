function toggle_ROIs(handles,molecules,num_mol)

    numbers_on = handles.toggle_numbers.Value;
    for i=1:num_mol
        if numbers_on
            molecules(i).text_num.Visible = 'on';
        else
            molecules(i).text_num.Visible = 'off';
        end
    end
    