function selected_molecules_list_Callback(hObject, eventdata, handles)

    [molecules,num_mol] = get_current_molecules(handles);

    if num_mol>0
%         selection = get_current_molecule_selection(handles);
        if handles.selected_molecules_list.Value > 0
            handles.molecule_list.Value = [];
        end
    
        pause(0.00001);
        if ~getappdata(0,'acquisition')
            handles = update_molecule_text_num_colors(handles);
            analysis = get_current_analysis(handles);
            handles = plot_graphs(handles,0,1,analysis,0);
        end
    end

    %%
    plot_click(handles);

    update_handles(handles.figure1, handles);