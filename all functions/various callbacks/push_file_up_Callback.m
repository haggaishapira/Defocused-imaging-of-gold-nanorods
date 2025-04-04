function push_file_up_Callback(hObject, eventdata, handles)

    num_files = handles.num_files;

    if num_files>0
        file_num = handles.file_list.Value;
        if file_num > 1
            % update file list
            temp_str = handles.file_list.String{file_num-1};
            handles.file_list.String{file_num-1} = handles.file_list.String{file_num} ;
            handles.file_list.String{file_num} = temp_str;
            handles.file_list.Value = file_num - 1;

            % update file struct
            temp_file_metadata = handles.file_metadatas(file_num-1);
            handles.file_metadatas(file_num-1) = handles.file_metadatas(file_num);
            handles.file_metadatas(file_num) = temp_file_metadata;
            handles.current_file_num = handles.current_file_num - 1;

            % update analyses struct
            temp_analysis = handles.analyses(file_num-1);
            handles.analyses(file_num-1) = handles.analyses(file_num);
            handles.analyses(file_num) = temp_analysis;

            % update sequence info struct
            temp_sequence_info = handles.sequence_infos(file_num-1);
            handles.sequence_infos(file_num-1) = handles.sequence_infos(file_num);
            handles.sequence_infos(file_num) = temp_sequence_info;

            % update selection struct
            temp_selection = handles.molecule_selections(file_num-1);
            handles.molecule_selections(file_num-1) = handles.molecule_selections(file_num);
            handles.molecule_selections(file_num) = temp_selection;

        end
    end
    update_handles(hObject,handles);








