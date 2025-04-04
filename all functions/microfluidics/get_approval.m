function res = get_approval(conn,num)

    str_num = num2str(num);
    disp('asking saved approval');
    % get approval of saved file
    str = read(conn,1,'string');
    if strcmp(str,str_num)
        res = 1;
        disp('received saved approval');
    else
        res = 0;
        disp('error with saved approval');
    end
