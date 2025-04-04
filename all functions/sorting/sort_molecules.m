function sorted_molecules = sort_molecules(handles,molecules,num_mol)

%     [molecules,num_mol] = get_current_molecules(handles);
%     curr_file = handles.current_file_num;
%     val = handles.sort_type.Value;

%     num_table = val;

    field_num = handles.sort_type.Value;
    field_str = handles.sort_type.String{field_num};
    
    curr_frame = round(handles.slider_frames.Value);

%     if ~handles.ascending
%         field_num = -field_num;
%         num_table = -num_table;
%     end

%     %find number
%     found = 0;
%     names = fieldnames(molecules);
%     for i=1:size(names,1)
%         if strcmp(names{i},field_str)
%             num_struct = i;
%             found = 1;
%             break;
%         end
%     end
%     if ~found
%         msgdlg('error sorting. variable does not exist');
%         return;
%     end

%     handles.ax_table.Data = sortrows(handles.ax_table.Data, num_table);

    sorted_molecules = sorting_function(molecules,num_mol,field_str,curr_frame);
%     sorted_molecules = sort_struct_by_field(molecules, num_struct);
    
%     curr_file_num = handles.current_file_num;
%     handles.analyses(curr_file_num).molecules = sorted_molecules;
% %     handles = set_molecules(handles,curr_file,sorted_molecules);
%     handles = initialize_molecule_list(handles, sorted_molecules);












