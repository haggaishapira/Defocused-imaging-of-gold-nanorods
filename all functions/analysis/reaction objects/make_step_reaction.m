function step_reaction = make_step_reaction(start_time,state_1,state_2,intermediate,state_mid,step_t_1,step_t_2,...
    anti_fuel_num,fitting_t,fitted_trace,clockwise,stepping_error)

    step_reaction.start_time = start_time;
    step_reaction.step_t_1 = step_t_1;
    step_reaction.relative_step_t_1 = step_t_1 - start_time;
    step_reaction.step_t_2 = step_t_2;
    step_reaction.relative_step_t_2 = step_t_2 - start_time;
    
    step_reaction.state_1 = state_1;
    step_reaction.state_2 = state_2;
    step_reaction.state_mid = state_mid;
    step_reaction.intermediate = intermediate;

    if intermediate
        step_reaction.step_size_1 = state_mid - state_1;
        step_reaction.step_size_2 = state_2 - state_mid;
    else
        step_reaction.step_size_1 = state_2 - state_1;
        step_reaction.step_size_2 = 0;
    end
    step_reaction.step_size_total = state_2 - state_1;
    
    step_reaction.anti_fuel_num = anti_fuel_num;
    step_reaction.clockwise = clockwise;
    step_reaction.fitting_t = fitting_t;
    step_reaction.fitted_trace = fitted_trace;
    step_reaction.is_error = stepping_error;
%     step_reaction.num_changes = num_changes;

    
