function show_temp(handles)

    [ret,temp] = GetTemperature();
    handles.temp.String = num2str(temp);