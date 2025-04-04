function final_str = clock_to_string()
    
    vec = clock;

    year = vec(1);
    month = vec(2);
    day = vec(3);
    hour = vec(4);
    minute = vec(5);
    sec = vec(6);

    year_str = num2str(year);
    year_str = year_str(3:4);

    month_str = num2str(month);
    month_str = pad_with_zero(month_str);

    day_str = num2str(day);
    day_str = pad_with_zero(day_str);

    hour_str = num2str(hour);
    hour_str = pad_with_zero(hour_str);

    minute_str = num2str(minute);
    minute_str = pad_with_zero(minute_str);

    sec_str = num2str(sec);
    bef = extractBefore(sec_str,'.');
    sec_str = pad_with_zero(bef);

    final_str = [year_str month_str day_str hour_str minute_str sec_str];



    
