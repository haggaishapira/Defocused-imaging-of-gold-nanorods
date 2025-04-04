function TIRF_calculate_background_Callback(hObject, eventdata, handles)

    analysis = get_current_analysis(handles);

    trace_green = analysis.trace_green;
    trace_red = analysis.trace_red;

    avg_green = mean(trace_green);
    avg_red = mean(trace_red);

    handles.TIRF_background_green_output.String = sprintf('%.0f',avg_green);
    handles.TIRF_background_red_output.String = sprintf('%.0f',avg_red);

    update_handles(hObject,handles);