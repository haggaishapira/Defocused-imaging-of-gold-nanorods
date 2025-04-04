function fuel_array = get_fuel_activity_F_AF(misc_molecules,first_t,last_t)

    fuel_array = zeros(1,6);
%     fuel_array = [];

    for  i=1:6
        immobilization_reactions = get_data_simple(misc_molecules,'immobilization_reactions');
        immobilization_reactions = get_immobilization_reactions_specific_fuel_and_time(immobilization_reactions(:),i,first_t,last_t);
        times = get_data_simple(immobilization_reactions,'relative_immobilization_time');

        num_responsive = length(times(times<inf));
        num_unresponsive = length(isinf(times));
%         fuel_array(i) = fuel_array(i) + length(filtered_immobilization_reactions);
%        len = length(filtered_immobilization_reactions); 
%         fuel_array = [fuel_array; i*ones(num_filtered,1)];
        
        fuel_array(i) = num_responsive / (num_responsive + num_unresponsive);
    end
