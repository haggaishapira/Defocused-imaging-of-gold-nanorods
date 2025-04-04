function choose_output_number_Callback(hObject, eventdata, handles)
    if ~getappdata(0,'acquisition')
        analysis = get_current_analysis(handles);
        handles = plot_graphs(handles,0,1,analysis,0);
        update_handles(handles.figure1,handles);
    end
