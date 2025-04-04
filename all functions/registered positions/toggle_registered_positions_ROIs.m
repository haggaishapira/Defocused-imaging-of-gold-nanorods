function handles = toggle_registered_positions_ROIs(handles)


    visible = handles.toggle_registered_positions_ROIs.Value;

    positions = handles.registered_positions;
    if isempty(positions)
        if visible
            msgbox('no positions registered');
        end
        return;
    end

    num_ROIs = size(positions,1);

    ROI_handles = handles.registered_positions_ROI_handles;
    if isempty(ROI_handles)
        ROIs = handles.registered_positions_ROIs;
        ROI_handles = add_ROIs_registered_positions(handles,ROIs,visible);
        handles.registered_positions_ROI_handles = ROI_handles;
    else   
        for i=1:num_ROIs
    %         try
                handles.registered_positions_ROI_handles(i).Visible = visible;
    %         catch e        
        end
    end
    
%     disp(positions(1,:));


    update_handles(handles.figure1, handles);

    
