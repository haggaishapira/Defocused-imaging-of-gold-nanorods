function apply_molecule_selection_Callback(hObject, eventdata, handles)

    % get selection and apply it to selected files
    registered_molecule_selections = handles.registered_molecule_selections;
    num_files_registered = size(registered_molecule_selections,2);

    % selected files
    file_selection = handles.file_list.Value;
    num_files_selected = length(file_selection);

    % check mismatch
    if num_files_registered ~= num_files_selected
        str = sprintf(['mismatch between number of files registered and ber of files registered.\n' ...
                       '%d files registered, %d files selected.'], num_files_registered, num_files_selected);
        msgbox(str);
        return;
    end

%     molecule_selections = handles.molecule_selections;
    num_mol_total = 0;
    for i=1:num_files_selected
        file_num = file_selection(i);
        molecule_selection = registered_molecule_selections{i};

        % unsafe if mismatch in molecule number, but assume user knows to beware.
        handles.molecule_selections{file_num} = molecule_selection; 
        num_mol_total = num_mol_total + length(molecule_selection);

        % set as molecules of interest - a "hard" parameter, for filtering later
        analysis = handles.analyses(file_num); 
        num_mol = analysis.num_mol;
        for j=1:num_mol
            num = analysis.molecules(j).num;
            analysis.molecules(j).molecule_of_interest = ismember(num, molecule_selection);
        end
        handles = set_analysis(handles,file_num,analysis,0);


    end
    msgbox(sprintf('applied selection for %d files, with a total of %d molecules', num_files_selected, num_mol_total));

    % get the selection of current file to use it here
    molecule_selection = get_current_molecule_selection(handles);

    % code duplication with load molecule selection callback, but whatever.
    [current_molecules,num_mol_curr] = get_current_molecules(handles);

    handles = initialize_molecule_list(handles, current_molecules);
    

    if isempty(molecule_selection)
        handles.molecule_list.Value = 1;
        handles.selected_molecules_list.Value = [];
    else
        handles.molecule_list.Value = [];
        handles.selected_molecules_list.Value = 1;
    end

    handles = update_molecule_text_num_colors(handles);
    analysis = get_current_analysis(handles);
    handles = plot_graphs(handles,0,1,analysis,0);
        
    update_handles(handles.figure1, handles);











