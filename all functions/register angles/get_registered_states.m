function registered_states = get_registered_states(handles,num_states)

%     handles.registered_phi_states_curr_mol = 
    registered_states = handles.registered_phi_states_curr_mol;
    
    if length(registered_states) ~= num_states
        registered_states = zeros(1,num_states);
    end


    