function streaks = calculate_streaks(molecule, first_t, last_t, settings)

    curr_streak = 0;
    streaks = [];
    step_reactions = get_data_simple(molecule,'step_reactions');                    
    num_steps = length(step_reactions);
    
    for j=1:num_steps
        step = step_reactions(j);
        condition = 1;
        condition = condition & (~isempty(filter_step_reactions(step,1:6,first_t,last_t,settings)));
%         condition2 = condition & (step.start_time >= first_t || step.start_time <= last_t);
%         condition = condition & (~step.is_error);
                     
        if condition
            curr_streak = curr_streak + 1;
        else 
            if curr_streak > 0
                streaks = [streaks; curr_streak];
            end
%             disp(curr_streak);
            curr_streak = 0;
        end
    end
    1;