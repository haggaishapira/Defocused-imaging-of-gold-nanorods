function handles = write_data_in_table(handles)

    [molecules,num_mol] = get_current_molecules(handles);
    curr_frame = round(handles.slider_frames.Value);

    % make table
    fields = handles.sort_type.String;
%     fields = {'num','y','x','dissociation_time','preferred_phi','release_time'};
    num_fields = length(fields);

    handles.ax_table.ColumnName = fields;
    table = zeros(num_mol,num_fields);

    for i=1:num_fields
        field_str = fields{i};
        data = get_specific_data_from_field(molecules,field_str,curr_frame);
        table(:,i) = data;
    end

    handles.ax_table.Data = table;




    