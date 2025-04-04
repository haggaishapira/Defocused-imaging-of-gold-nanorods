function reset_FH12_positions_Callback(hObject, eventdata, handles)

function register_FH12_positions_Callback(hObject, eventdata, handles)
    

    % do it for multiple files

    file_selection = handles.file_list.Value;

    registered_FH12_positions = {};
    analyses = handles.analyses;
    num_files_selected = length(file_selection);
    num_mol_total = 0;
    for i=1:num_files_selected
        file_num = file_selection(i);
        molecules = analyses(file_num).molecules;
        FH12_positions = cell2mat({molecules.FH12_position});
        FH12_positions(:) = 0;
        registered_FH12_positions{i} = FH12_positions;
        num_mol_total = num_mol_total + size(molecules,2);
    end
    handles.registered_FH12_positions = registered_FH12_positions;
    msgbox(sprintf('registered FH12 positions for %d files with a total of %d molecules',num_files_selected, num_mol_total));


    update_handles(handles.figure1,handles);















