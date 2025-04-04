function sequence_info = make_empty_sequence_info()

    sequence_info.empty = 1;

    sequence_info.sequence = [];
    sequence_info.num_steps = [];
    sequence_info.times = [];
    sequence_info.num_cycles = [];
    sequence_info.command_names = [];
    sequence_info.total_time = [];
    sequence_info.time_intervals = [];
    sequence_info.command_names_full_sequence = [];
    sequence_info.num_valves = [];
    sequence_info.total_num_steps = [];

    sequence_info.num_fuel_commands = 0;
    sequence_info.num_anti_fuel_commands = 0;
    