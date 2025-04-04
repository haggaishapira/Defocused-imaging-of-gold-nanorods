function remove_molecule_from_selected_Callback(hObject, eventdata, handles)

    val_selected = handles.selected_molecules_list.Value;
    if isempty(val_selected)
        return;
    end

    molecule = get_curr_mol_selected(handles);
    num = molecule.num;

    molecule_selection = get_current_molecule_selection(handles);
    num_selected = length(molecule_selection);

    molecule_selection = setdiff(molecule_selection,num);

    handles = set_molecule_selection(handles,molecule_selection);

    [current_molecules,num_mol_curr] = get_current_molecules(handles);

    
    % save value
%     num_selected = size(handles.selected_molecules_list.String);
    

    handles = initialize_molecule_list(handles, current_molecules);   

    % set value
    if val_selected == num_selected
        if val_selected == 1
            % move to other list
            handles.selected_molecules_list.Value = [];
            handles.molecule_list.Value = 1;
        else
            handles.selected_molecules_list.Value = val_selected - 1;
            handles.molecule_list.Value = [];
        end
    else
        handles.selected_molecules_list.Value = val_selected;
        handles.molecule_list.Value = [];
    end

%     handles = update_real_num(handles);

   if ~getappdata(0,'acquisition')
        handles = update_molecule_text_num_colors(handles);
        analysis = get_current_analysis(handles);
        handles = plot_graphs(handles,0,1,analysis,0);
   end
   
    update_handles(handles.figure1, handles);

%     molecule_list_Callback(handles.figure1,eventdata,handles);




