function filtered_reactions = get_immobilization_reactions_specific_fuel_and_time(reactions,num,first_t,last_t)

    filtered_reactions = [];
    if ~isempty(reactions)
        for i=1:length(reactions)
            if ~ismember(reactions(i).fuel_number,num)
                continue;
            end
            if reactions(i).start_time < first_t || reactions(i).start_time > last_t
                continue;
            end
            filtered_reactions = [filtered_reactions; reactions(i)];
        end      
    end
