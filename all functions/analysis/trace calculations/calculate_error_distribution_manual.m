function fuel_array = calculate_error_distribution_manual(misc_molecules,first_t,last_t,settings)

    fuel_array = zeros(1,6);
%     fuel_array = [];

%     settings.min_step_size = -inf;
%     settings.max_step_size = inf;

    step_reactions = get_data_simple(misc_molecules,'step_reactions');
    step_reactions = step_reactions(:);
    
%     max_abs_step_size = 5;

    for  i=1:6
%         filtered_step_reactions = filter_step_reactions(step_reactions(:),i,first_t,last_t,settings);

        num_error = 0;
        num_success = 0;
        for j=1:length(step_reactions)
            step = step_reactions(j);
            if ~ismember(step.anti_fuel_num,i)
                continue;
            end
            if step.start_time < first_t || step.start_time > last_t
                continue;
            end
            
            if step.is_error
                num_error = num_error + 1;
            else
                num_success = num_success + 1;
            end
        end
%         relative_num_error = num_error / (num_error + num_success);
%         fuel_array(i) = relative_num_error;
        fuel_array(i) = num_error;
    end

    %%% error in anti fuel number means the correct number is next modulo fuel %%%
    % represent as fuel distribution, not anti fuel distribution?
    shifted_array = [fuel_array(6) fuel_array(1) fuel_array(2) fuel_array(3) fuel_array(4) fuel_array(5)];
    fuel_array = shifted_array;



end







