function truth_table = calculate_truth_table_Callback(hObject, eventdata, handles)

    truth_table = calculate_truth_table(handles);
    
%     disp(truth_table);
%     num_mol_all = size(truth_table,1);

    num_batches = size(handles.batches,1);
    for i=1:num_batches
        mol_counter = 1;
        disp(mol_counter);
        id_nums = handles.batches(i).id_nums;
        for j=1:length(id_nums)
            file_num = file_num_from_id(handles,id_nums(j));
            num_mol = handles.analyses(file_num).num_mol;
            for k=1:num_mol
                mol_results = truth_table(mol_counter,:);
                num_matches = length(find(mol_results>0));
%                 stuck_correctly = mol_results(i) > 0;
                handles.analyses(file_num).molecules(k).num_matches = num_matches;
%                 handles.analyses(file_num).molecules(k).stuck_correctly = stuck_correctly;
                mol_counter = mol_counter + 1;
            end
        end
    end

    msgbox('calculated and updated truth table');

    update_handles(hObject,handles);












