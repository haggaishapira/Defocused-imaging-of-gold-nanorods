function delete_molecule_Callback(hObject, eventdata, handles)
    
%     [molecules,num_mol] = get_current_molecules(handles);
    analysis = get_current_analysis(handles);

    num_mol = analysis.num_mol;

    if num_mol == 0
        return;
    end

    mol = handles.molecule_list.Value;
    analysis.molecules(mol) = delete_molecule_display_objects(analysis.molecules(mol));
%     handles.all_lines(mol*3-2:mol*3) = [];
    analysis.molecules(:,mol) = [];
    analysis.num_mol = num_mol - 1;

    handles.all_lines = make_lines_array(analysis.molecules,num_mol-1);
    handles.all_lines_reference = make_lines_array(analysis.molecules,num_mol-1);

%     handles = set_molecules(handles,handles.current_file_num,molecules);

    if mol == num_mol
%         new_curr_mol_num = max(mol-1, 1);
        new_curr_mol_num = mol-1;
    else
        new_curr_mol_num = mol;
    end

    handles.curr_mol_num = new_curr_mol_num;
    handles.molecule_list.String(mol,:) = [];
    handles.molecule_list.Value = new_curr_mol_num;

    if new_curr_mol_num > 0    
        curr_mol = analysis.molecules(new_curr_mol_num); 
        handles.curr_mol_real_num = curr_mol.num;
    end
    
    curr_file_num = handles.current_file_num;
    
    handles = set_analysis(handles,curr_file_num,analysis,0);

    % selected molecules
%     handles.selected_molecules_list.String(mol,:) = [];
%     handles.selected_molecules_list.Max = num_mol-1;


    update_handles(hObject,handles);
    
    molecule_list_Callback(handles.molecule_list, eventdata, handles);

















