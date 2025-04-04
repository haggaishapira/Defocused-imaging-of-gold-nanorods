function sequence_info = process_sequence_info(settings,sequence_info)


%     sequence_info: sequence
%                    num_steps
%                    times
%                    num_cycles
%                    command_names
%                    total_time
%                    time_intervals
%                    names_full_sequence

    sequence_info.empty = 0;

    sequence = sequence_info.sequence;
    num_valves = size(sequence,2);
    sequence_info.num_valves = num_valves;
    
    times = sequence_info.times;
    num_cycles = sequence_info.num_cycles ;
    
    sequence_info.total_num_steps = length(times) * num_cycles;

    time_intervals = zeros(sequence_info.total_num_steps,2);
%     sequence_info.full_sequence = zeros(sequence_info.total_num_steps,num_valves);
    sequence_info.command_names_full_sequence = {};

    start_time = settings.start_time;

%     curr_t = 0;
    curr_t = start_time;

    curr_step_total = 1;
    for i=1:num_cycles
        for j=1:sequence_info.num_steps
            t1 = curr_t;
            t2 = curr_t + times(j);
            time_intervals(curr_step_total,:) = [t1 t2];
            curr_t = t2;

            % find current command from sequences
            % <= 40 are the commands
            curr_combo = sequence(j,1:40);
            curr_command_ind = find(curr_combo>0);
            if ~isempty(curr_command_ind)
                curr_command_name = sequence_info.command_names{curr_command_ind};
            else
                curr_command_name = '';
            end
            sequence_info.command_names_full_sequence{curr_step_total} = curr_command_name;
%             sequence_info.full_sequence(curr_step_total,:) = sequence(j,:);
            
            curr_step_total = curr_step_total + 1;
        end
    end

    sequence_info.command_names_full_sequence = (sequence_info.command_names_full_sequence)';

    sequence_info.total_time = sum(sequence_info.times) * sequence_info.num_cycles;

    sequence_info.time_intervals = time_intervals;

    













    