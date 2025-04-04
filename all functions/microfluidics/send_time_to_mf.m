function send_time_to_mf(handles,t)

    settings = handles.microfluidics_settings;
    conn = handles.microfluidics_connection;

    str_msg = '6';
    response_ok = send_message_and_test_response(conn,str_msg);  

    if ~response_ok
%         msgbox('error sending time');
        disp('error sending time');
        return;
    end

    num_to_send = t;
    send_number(conn,num_to_send);

    disp('finished sending time');