function delta_phi_Callback(hObject, eventdata, handles)

    if ~getappdata(0,'acquisition')
        analysis = get_current_analysis(handles);
        handles = plot_graphs(handles,0,0,analysis,0);
    end

    update_handles(handles.figure1, handles);

