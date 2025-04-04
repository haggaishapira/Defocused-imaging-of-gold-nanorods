function handles = apply_area_deltas(handles)

    delta_x = str2num(handles.area_delta_x.String);
    delta_y = str2num(handles.area_delta_y.String);
    delta_x = round(delta_x);
    delta_y = round(delta_y);

    num_pos = size(handles.registered_positions,1);
    for i=1:num_pos
        handles.registered_positions(i,1:2) = handles.registered_positions(i,1:2) + [delta_x delta_y];
        handles.registered_positions_ROIs(i,1:2) = handles.registered_positions_ROIs(i,1:2) + [delta_x delta_y];
        if ~isempty(handles.registered_positions_ROI_handles)
            handles.registered_positions_ROI_handles(i).Position = handles.registered_positions_ROIs(i,:);
        end
    end

    disp(handles.registered_positions(1,1:2));
%     msgbox('applied area deltas');