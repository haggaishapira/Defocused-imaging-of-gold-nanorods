function fuel_array = calculate_no_response_distribution_hmm(misc_molecules,first_t,last_t,settings)

    fuel_array = zeros(1,6);
%     fuel_array = [];

    settings.min_step_size = -inf;
    settings.max_step_size = inf;

    step_reactions = get_data_simple(misc_molecules,'step_reactions');
    step_reactions = step_reactions(:);
    
    max_abs_step_size = 5;

    for  i=1:6
%         filtered_step_reactions = filter_step_reactions(step_reactions(:),i,first_t,last_t,settings);

        num_responsive = 0;
        num_unresponsive = 0;
        for j=1:length(step_reactions)
            step = step_reactions(j);
            if ~ismember(step.anti_fuel_num,i)
                continue;
            end
            if step.start_time < first_t || step.start_time > last_t
                continue;
            end
            if abs(step.step_size) > max_abs_step_size
                num_responsive = num_responsive + 1;
            else
                num_unresponsive = num_unresponsive + 1;
            end
        end
%         relative_num_unresponsive = num_unresponsive / (num_responsive + num_unresponsive);
%         fuel_array(i) = relative_num_unresponsive;
        fuel_array(i) = num_unresponsive;

    end
       
end







