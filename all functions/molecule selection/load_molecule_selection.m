function handles = load_molecule_selection(handles)

%     file_num = handles.file_list.Value;



    file_selection = handles.file_list.Value;
    num_files_selected = length(file_selection);
    for i=1:num_files_selected
        file_num = file_selection(i);

        file_metadata = handles.file_metadatas(file_num);
        full_name = file_metadata.full_name;
    
        [pathname, filename, extension] = fileparts(full_name);    
        path_and_filename = [pathname '\' filename '_molecule_selection.mat'];
    
        if handles.select_molecule_selection.Value
            [filename, pathname] = uigetfile([pathname '\' '*_molecule_selection.mat'],'choose molecule selection file');
            if path_and_filename
                path_and_filename = [pathname '\' filename];
            end
        end
    
        try
            selection = load(path_and_filename);    
            selection = selection.molecule_selection;
        catch
            selection = [];
        end
    
    %     file_num = handles.current_file_num;
    %     handles.molecule_selections{file_num} = selection;
%         handles = set_molecule_selection(handles,selection);
         handles.molecule_selections{file_num} = selection;

    end

    









