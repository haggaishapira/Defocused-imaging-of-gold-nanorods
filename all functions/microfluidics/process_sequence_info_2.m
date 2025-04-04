function sequence_info = process_sequence_info_2(sequence_info)
    fuel_group = get_fuel_group();
    anti_fuel_group = get_anti_fuel_group();

    command_names = sequence_info.command_names_full_sequence;
    for i=1:sequence_info.total_num_steps
        command_name = command_names{i};
        switch command_name
            case fuel_group
                sequence_info.num_fuel_commands = sequence_info.num_fuel_commands + 1;
            case anti_fuel_group
                sequence_info.num_anti_fuel_commands = sequence_info.num_anti_fuel_commands + 1;
        end
    end
