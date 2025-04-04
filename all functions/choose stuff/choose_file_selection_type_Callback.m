function choose_file_selection_type_Callback(hObject, eventdata, handles)

    analysis = get_current_analysis(handles);
    handles = plot_graphs(handles,0,1,analysis,0);
    update_handles(handles.figure1, handles);