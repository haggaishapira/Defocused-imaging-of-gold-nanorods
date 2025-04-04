function success = save_molecule_selection(handles)

%     selected_molecules = get_selected_molecules(handles);
%     nums = cell2mat({selected_molecules.num});

    % batch save selection

%     molecule_selection = get_current_molecule_selection(handles);
%     num_files = handles.num_files;
    file_selection = handles.file_list.Value;
    num_files_selected = length(file_selection);

    wait_bar = waitbar(0,sprintf('file %d/%d', 0,num_files_selected));
    for i=1:num_files_selected
        file_num = file_selection(i);
        molecule_selection = handles.molecule_selections{file_num};
        file_metadata = handles.file_metadatas(file_num);
        full_name = file_metadata.full_name;
    
        [pathname, filename, extension] = fileparts(full_name);
    
        path_and_filename = [pathname '\' filename '_molecule_selection'];
    
        custom_name = handles.custom_name_save_molecule_selection.Value;
    
        success = 1;
        if custom_name
    %         uisave('nums',[path_and_filename '.mat']);
             [filename, pathname] = uiputfile([path_and_filename '.mat']);
             if ~pathname
                 success = 0;
             else
                 path_and_filename = [pathname '\' filename];
                 save(path_and_filename,'molecule_selection','-mat');
             end
        else
            save([path_and_filename '.mat'],'molecule_selection','-mat');    
        end
        waitbar(i/num_files_selected,wait_bar,sprintf('file %d/%d', i,num_files_selected));

    end
    close(wait_bar);

    msgbox(sprintf('saved molecule selection for %d files',num_files_selected));


    
    
 
    






