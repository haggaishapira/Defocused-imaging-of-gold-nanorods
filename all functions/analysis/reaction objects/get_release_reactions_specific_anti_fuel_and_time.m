function filtered_reactions = get_release_reactions_specific_anti_fuel_and_time(reactions,num,first_t,last_t)

    filtered_reactions = [];
    if ~isempty(reactions)
        for i=1:length(reactions)
%             disp(reactions(i).anti_fuel_number);
            if ~ismember(reactions(i).anti_fuel_number,num)
                continue;
            end
            if reactions(i).start_time < first_t || reactions(i).start_time > last_t
                continue;
            end

            % filter release time
            min_release_time = 0;
%             min_release_time = 60;
            if reactions(i).relative_release_time < min_release_time
%                 continue;
            end

            filtered_reactions = [filtered_reactions; reactions(i)];
        end      
    end
