function send_number(conn,num)

    num_str = num2str(num,'%05.f');

    write(conn,num_str,'string');
    

