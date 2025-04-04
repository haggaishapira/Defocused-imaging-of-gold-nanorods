function num = read_number(conn)

    % 5 bytes
    str = read(conn,5,'string');
    num = str2num(str);
    
