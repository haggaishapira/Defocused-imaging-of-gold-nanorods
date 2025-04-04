function handles = apply_filters(handles)
    
    apply_filters = handles.apply_filters.Value;

    % iterate molecule selections
    num_files = handles.num_files;
    for i=1:num_files
        analysis = handles.analyses(i);
        molecules = analysis.molecules;
%         [filtered_molecules,num_filtered_mol] = filter_molecules(handles,molecules,analysis.num_mol);
        if apply_filters
            filtered_molecules_selection = filter_molecules(handles,molecules,analysis.num_mol);
        else
            filtered_molecules_selection = [];
        end
        handles.molecule_selections{i} = filtered_molecules_selection;
    end


    analysis = get_current_analysis(handles);
    handles = initialize_molecule_list(handles, analysis.molecules);

    handles = frame_changed(handles,1,1);