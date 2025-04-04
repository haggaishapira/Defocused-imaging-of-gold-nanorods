function delete_all_files_Callback(hObject, eventdata, handles)
  
%     handles = delete_all_display_objects(handles);

%     handles = delete_all_current_molecules(handles);
    for i=1:handles.num_files
        if strcmp(handles.file_metadatas(i).extension, '.rdt')
            try
                fclose(handles.file_metadatas(i).rdt_file_descriptor);
            catch e
            end
        end
    end

    handles.file_metadatas = [];
    handles.sequence_infos = [];
    handles.file_list.Value = 1;
    handles.file_list.Max = 1;
    handles.file_list.String = cell(0,1);
    handles.num_files = 0;
    handles.current_file_num = 0;
%     initialize_ax_video(handles);
%     handles = update_frame(handles,1);
%     handles.molecule_sets = [];    
    handles.analyses = [];    
    handles.current_filename = '';
    handles.molecule_list.String = {};
    handles.selected_molecules_list.String = {};
    handles.molecule_selections = {};

    update_handles(hObject,handles);
