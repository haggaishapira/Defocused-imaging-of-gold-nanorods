function [sequence_info] = read_sequence_info_3(handles,filename_sequence)

    settings = handles.microfluidics_settings;

    sequence_info = [];
    conn = handles.microfluidics_connection;
    
    flush(conn);
    str_msg = '4';
    
    response_ok = send_message_and_test_response(conn,str_msg);  
    if ~response_ok
        msgbox('error loading sequence');
        return;
    end

    send_string(conn,filename_sequence);
        
    % get approval for mf finished saving matrix
    if get_approval(conn,4)
        % write all good
        % actually skip this, currently mf isnt waiting for it
    else
        return;
    end
    times_and_sequence = readmatrix(filename_sequence);
    
%     delete(filename_sequence);

    times = times_and_sequence(1,:);
    sequence = times_and_sequence(2:end,:);

    num_steps = read_number(conn);
    num_cycles = read_number(conn);   

    command_names = read_string(conn);

    disp('success getting sequence data!');

    sequence = sequence(1:num_steps,:);
    times = times(1:num_steps);

    command_names = strsplit(command_names,'_');
    command_names = arrayfun(@(x)char(command_names(x)),1:numel(command_names),'uni',false);
    command_names = command_names(1:end-1);
    command_names = cellfun(@(x) x(1:end-1), command_names,'UniformOutput', false);

    sequence_info = make_empty_sequence_info();

    sequence_info.sequence = sequence;
    sequence_info.num_steps = num_steps;
    sequence_info.times = times;
    sequence_info.num_cycles = num_cycles;
    sequence_info.command_names = command_names;

    sequence_info = process_sequence_info(settings,sequence_info);










