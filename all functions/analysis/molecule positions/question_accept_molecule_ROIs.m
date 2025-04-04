function answer = question_accept_molecule_ROIs(handles, molecules, num_mol)

    original_val = handles.toggle_ROIs.Value;
    handles.toggle_ROIs.Value = 1;
    toggle_ROIs(handles,molecules,num_mol);

    % choose if to accept ROIs
    opts.Interpreter = 'tex';
    opts.Default = 'Yes';
    answer = questdlg('accept molecule ROIs?', 'Choose if to accept ROIs', 'Yes', 'No', opts);

    if strcmp(answer,'Yes')
        answer = 1;
    else
        answer = 0;
    end

    
    handles.toggle_squares.Value = original_val;
    toggle_ROIs(handles,molecules,num_mol);
