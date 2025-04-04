function sort_type_Callback(hObject, eventdata, handles)

%     [molecules,num_mol] = get_current_molecules(handles);

    if getappdata(0,'acquisition') 
        return;
    end

    [molecules,num_mol] = get_current_molecules(handles);
    
    if num_mol == 0
        return;
    end
    sorted_molecules = sort_molecules(handles,molecules,num_mol);

    curr_file_num = handles.current_file_num;
    handles.analyses(curr_file_num).molecules = sorted_molecules;
    handles = initialize_molecule_list(handles, sorted_molecules);

    pause(0.00001);

    analysis = get_current_analysis(handles);
    handles = plot_graphs(handles,0,0,analysis,0);

    update_handles(handles.figure1,handles);



