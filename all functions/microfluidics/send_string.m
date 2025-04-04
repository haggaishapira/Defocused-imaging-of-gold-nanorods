function send_string(conn,str)
    
    num_bytes = length(str);
    num_bytes_str = num2str(num_bytes,'%05.f');
    write(conn,num_bytes_str,'string');    

    write(conn,str,'string');
    

