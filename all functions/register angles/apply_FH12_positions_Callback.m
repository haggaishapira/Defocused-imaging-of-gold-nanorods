function apply_FH12_positions_Callback(hObject, eventdata, handles)

    file_selection = handles.file_list.Value;

    registered_FH12_positions = handles.registered_FH12_positions;

    analyses = handles.analyses;
    num_files_selected = length(file_selection);
    for i=1:num_files_selected
        file_num = file_selection(i);
        FH12_positions = registered_FH12_positions{i};
        num_mol = analyses(file_num).num_mol;
        num_registered = length(FH12_positions);
        
        if num_registered ~= num_mol
            msgbox(sprintf('mismatch between number of molecules in file %d: %d registered vs %d applied. no action performed', i, num_registered,num_mol));
            return;
        end
%         disp(file_num);
%         disp(length(FH12_positions));
%         disp(num_mol);

        for j=1:num_mol
            analyses(file_num).molecules(j).FH12_position = FH12_positions(j);
        end
    end

    handles.analyses = analyses;
    msgbox(sprintf('applied FH12 positions for %d files',num_files_selected));

    update_handles(handles.figure1,handles);

