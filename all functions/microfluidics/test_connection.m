function connection_ok = test_connection(microfluidics_connection)

    try
        connection_ok = send_message_and_test_response(microfluidics_connection,'3');
        catch e
    end
    