function params = process_params(params)
    
    state_1 = params(1);
    state_2 = params(2);
    state_mid = params(3);
    frame_step_1 = round(params(4));
    frame_step_2 = round(params(5));
%     num_states

%     if abs(state_mid - state_1) <= 10
%         state_mid = state_1;
%     end
%     if abs(state_mid - state_2) <= 10
%         state_mid = state_2;
%     end

    params(1) = state_1;
    params(2) = state_2;
    params(3) = state_mid;
    params(4) = frame_step_1;
    params(5) = frame_step_2;


