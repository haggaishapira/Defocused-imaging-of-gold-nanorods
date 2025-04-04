function register_initial_states_Callback(hObject, eventdata, handles)


%     analysis = get_current_analysis(handles);
%     currnemolecules = analysis.molecules;

    curr_mol = get_current_molecules(handles);
    [all_mol,num_mol_all] = get_all_molecules(handles);

    initial_states_curr_mol = cell2mat({curr_mol.initial_state_phi});
    initial_states_all_mol = combine_molecule_data(1,all_mol,num_mol_all,'initial_state_phi',0,1,1,0);

    handles.registered_phi_states_curr_mol = initial_states_curr_mol;
    handles.registered_phi_states_all_mol = initial_states_all_mol;

    num_states_curr = length(initial_states_curr_mol);
%     num_states_all = length(initial_states_all_mol);
    
%     msgbox(sprintf('registered %d current molecule states\n and %d total molecule states',num_states_curr, num_states_all));
    msgbox(sprintf('registered %d current molecule states',num_states_curr));

    update_handles(handles.figure1,handles);
