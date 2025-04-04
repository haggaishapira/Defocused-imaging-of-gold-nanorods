function register_molecule_selection_Callback(hObject, eventdata, handles)

    file_selection = handles.file_list.Value;
    num_files_selected = length(file_selection);

    registered_molecule_selections = {};
    % get molecule selections
    num_mol_total = 0;
    for i=1:num_files_selected
        file_num = file_selection(i);
        molecule_selection = handles.molecule_selections{file_num};
        registered_molecule_selections{i} = molecule_selection;
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
    handles.registered_molecule_selections = registered_molecule_selections;

    update_handles(handles.figure1, handles);

    msgbox(sprintf('registered selection for %d files, with a total of %d molecules', num_files_selected, num_mol_total));