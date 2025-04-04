function register_final_states_Callback(hObject, eventdata, handles)
    
    
    curr_mol = get_current_molecules(handles);
    [all_mol,num_mol_all] = get_all_molecules(handles);

    final_states_curr_mol = cell2mat({curr_mol.final_state_phi});
    final_states_all_mol = combine_molecule_data(1,all_mol,num_mol_all,'final_state_phi',0,1,1,0);

    handles.registered_phi_states_curr_mol = final_states_curr_mol;
    handles.registered_phi_states_all_mol = final_states_all_mol;

    num_states_curr = length(final_states_curr_mol);
%     num_states_all = length(final_states_all_mol);
    
%     msgbox(sprintf('registered %d current molecule states\n and %d total molecule states',num_states_curr, num_states_all));
    msgbox(sprintf('registered %d current molecule states',num_states_curr));

    update_handles(handles.figure1,handles);
