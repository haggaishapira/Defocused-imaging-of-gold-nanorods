function load_molecule_selection_Callback(hObject, eventdata, handles)

    % load from file and save it to selection struct
    handles = load_molecule_selection(handles);

    % get the selection to use it here
    selection = get_current_molecule_selection(handles);

    [current_molecules,num_mol_curr] = get_current_molecules(handles);

    handles = initialize_molecule_list(handles, current_molecules);
    

    if isempty(selection)
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
    