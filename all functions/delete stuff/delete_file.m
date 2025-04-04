function handles = delete_file(handles)


%     disp_num_files_mols(handles);
%     return;

    if handles.num_files == 0
        return;
    end

    file_selection = handles.file_list.Value;
    
%         file_num = handles.current_file_num; % strategically safer to make sure this is correct

    num_files = length(file_selection);
    for i=num_files:-1:1
        file_num = file_selection(i);
        handles = delete_all_display_objects(handles,file_num);    
    
        % update value of list before reducing its size
        if file_num == handles.num_files
    %         new_file_num = max(file_num-1, 1);
            new_file_num = file_num-1;
        else
            new_file_num = file_num;
        end    
        handles.file_list.Value = new_file_num;
        
    
        handles.file_metadatas(file_num) = [];
        handles.file_list.String(file_num,:) = [];
        handles.num_files = handles.num_files - 1;
        handles.analyses(file_num,:) = [];
        handles.sequence_infos(file_num) = [];
        handles.molecule_list.String = {};
        handles.selected_molecules_list.String = {};
        handles.molecule_selections(file_num) = [];
    
        handles.file_list.Max = handles.num_files;  
    
        handles.current_file_num = new_file_num;
    
        if handles.num_files > 0
            handles = select_file(handles,new_file_num,0);
        end
    end

%     disp_num_files_mols(handles);

