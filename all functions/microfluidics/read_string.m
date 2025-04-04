function str = read_string(conn)
    
    num_bytes_str = read(conn,5,'string');
    num_bytes = str2num(num_bytes_str);
   
    str = read(conn,num_bytes,'string');
    


