function send_sequence_to_microfluidics(handles,filename_sequence,sequence_info)

    settings = handles.microfluidics_settings;
    conn = handles.microfluidics_connection;
    
    flush(conn);
    str_msg = '5';

    response_ok = send_message_and_test_response(conn,str_msg);  
    if ~response_ok
        msgbox('error sending sequence');
        return;
    end

    % check if the file exists in the folder first and if not, create it
    if 1
        row_times = sequence_info.times;
        sequence = sequence_info.sequence;

        h = sequence_info.num_steps + 1;
        w = sequence_info.num_valves;
        combined_matrix = zeros(h,w);
        combined_matrix(1,1:sequence_info.num_steps) = row_times;
        combined_matrix(2:end,:) = sequence;
%         writematrix(combined_matrix,filename_sequence);
        writematrix(num2str(combined_matrix,'%.3f\t'),filename_sequence);
%         writematrix(combined_matrix,filename_sequence, 'Delimiter', 'tab');
        
    end
%     return;

    send_string(conn,filename_sequence);

    
    num_steps = sequence_info.num_steps;  
    send_number(conn,num_steps);

    num_cycles = sequence_info.num_cycles;  
    send_number(conn,num_cycles);

    disp('finished sending');

    