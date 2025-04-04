function response_ok = send_message_and_test_response(microfluidics_connection,str_msg)
        
    try
%         disp('testing response');
        write(microfluidics_connection,str_msg,'string');

        str = read(microfluidics_connection,1,'string');
        
%         disp(str);
        
        if strcmp(str,str_msg)
%             disp('connection ok');
            response_ok = 1;
        else
            response_ok = 0;
        end
    catch e
        response_ok = 0;
    end