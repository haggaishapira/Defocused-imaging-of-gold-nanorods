function add_molecule_to_selected_Callback(hObject, eventdata, handles)

%     val = handles.molecule_list.Value;
%     str = handles.molecule_list.String{val};

    val_non_selected = handles.molecule_list.Value;
    if isempty(val_non_selected)
        return;
    end
    

    molecule = get_curr_mol_non_selected(handles);
    num = molecule.num;

    molecule_selection = get_current_molecule_selection(handles);

    [current_molecules,num_mol_curr] = get_current_molecules(handles);
    num_non_selected = num_mol_curr - length(molecule_selection);


    molecule_selection = [molecule_selection num];
    molecule_selection = sort(molecule_selection);
    
    handles = set_molecule_selection(handles,molecule_selection);

    

    % save vals
%     val_non_selected = handles.molecule_list.Value;
%     val_selected = handles.selected_molecules_list.Value;
%     num_non_selected = size(handles.molecule_list.String);

    handles = initialize_molecule_list(handles, current_molecules);

    % real num bug
%     molecule = get_disp_mol(handles);
    handles.curr_mol_real_num = num;

    if val_non_selected == num_non_selected
        if val_non_selected == 1
            % move to other list
            handles.molecule_list.Value = [];
            handles.selected_molecules_list.Value = 1;
        else
            handles.molecule_list.Value = val_non_selected - 1;
            handles.selected_molecules_list.Value = [];
        end
    else
        handles.molecule_list.Value = val_non_selected;
        handles.selected_molecules_list.Value = [];
    end

%     handles = update_real_num(handles);


    if ~getappdata(0,'acquisition')
        handles = update_molecule_text_num_colors(handles);
        analysis = get_current_analysis(handles);
        handles = plot_graphs(handles,0,1,analysis,0);
    end
       
    update_handles(handles.figure1, handles);

%     molecule_list_Callback(handles.figure1,eventdata,handles);


