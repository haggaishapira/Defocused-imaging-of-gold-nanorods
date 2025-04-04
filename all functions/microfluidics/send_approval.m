function send_approval(conn,num)

    str = num2str(num);
    write(conn,str,'string');
    
