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
        registered_FH12_positions{i} = FH12_positions;
        num_mol_total = num_mol_total + size(molecules,2);
    end
    handles.registered_FH12_positions = registered_FH12_positions;
    msgbox(sprintf('registered FH12 positions for %d files with a total of %d molecules',num_files_selected, num_mol_total));


%     [molecules,num_mol] = get_current_molecules(handles);
% 
%     FH12_positions = cell2mat({molecules.FH12_position});
%     nums = cell2mat({molecules.num});
% 
%     
%     handles.registered_FH12_positions = FH12_positions;
%     handles.registered_FH12_positions_nums = nums;

%     wait_bar = waitbar(1,sprintf('registering positions'));
%     pause(0.2);
%     close(wait_bar);

    update_handles(handles.figure1,handles);















