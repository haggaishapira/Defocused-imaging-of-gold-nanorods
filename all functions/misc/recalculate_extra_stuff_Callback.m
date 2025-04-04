function recalculate_extra_stuff_Callback(hObject, eventdata, handles)


    % do it for multiple files
    analyses = handles.analyses;
    file_selection = handles.file_list.Value;
    num_files_selected = length(file_selection);

    wait_bar_files = waitbar(0,sprintf('performing extra calculations. file %d/%d', 0,num_files_selected));
    wait_bar_files.Position(2) = wait_bar_files.Position(2) * 1.3;
    for i=1:num_files_selected
%         disp(i);
        file_num = file_selection(i);
        analysis = analyses(file_num);
        if analysis.num_mol>0
            analysis = perform_extra_calculations(handles,analysis,file_num,i,0);
            analysis.molecules = sort_molecules(handles,analysis.molecules,analysis.num_mol);
        end      
        handles = set_analysis(handles,file_num,analysis,0);
        waitbar(i/num_files_selected,wait_bar_files,sprintf('performing extra calculations. file %d/%d', i,num_files_selected));    
    end
    close(wait_bar_files);

    analysis = get_current_analysis(handles);
%     file_num = handles.current_file_num;

    handles = initialize_molecule_list(handles, analysis.molecules);
%     handles = set_analysis(handles,file_num,analysis,0);
    handles = frame_changed(handles,1,1);

    update_handles(handles.figure1,handles);
















