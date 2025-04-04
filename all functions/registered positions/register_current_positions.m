function handles = register_current_positions(handles,print)

    analysis = get_current_analysis(handles);
    if ~strcmp(analysis.analysis_mode,'rotation')
%         msgbox('wrong analysis mode');
        return;
    end

    % first delete previous ROI handles
    ROI_handles = handles.registered_positions_ROI_handles;
    num_ROIs = size(ROI_handles,1);
    for i=1:num_ROIs
%         try
            delete(ROI_handles(i));
%         catch e
%         end
    end

    num_mol = analysis.num_mol;
    
    %%%% DELETE!!! %%%
%     num_mol = 1;

    visible = handles.toggle_registered_positions_ROIs.Value;
    vid_len = analysis.vid_len;

    % position oriented, not ROI oriented, even though the drawing is by
    % ROI and it is saved throughout the analysis
    positions = zeros(num_mol,2);
    
    ROIs = zeros(num_mol,4);

%     frame_to_take = 1;
    frame_to_take = vid_len;

%     wait_bar = waitbar(0,sprintf('registering positions. molecule %d/%d', 0,num_mol));
    for i=1:num_mol
        ROI = analysis.molecules(i).ROI(frame_to_take,:);
        ROIs(i,:) = ROI;
        x = analysis.molecules(i).x(frame_to_take);
        y = analysis.molecules(i).y(frame_to_take);
        positions(i,:) = [x y];
%         waitbar(mol/num_mol,wait_bar,sprintf('registering positions. molecule %d/%d', i,num_mol));    
    end
%     close(wait_bar);


    ROI_handles = add_ROIs_registered_positions(handles,ROIs,visible);
    
    handles.registered_positions = positions;
    handles.registered_positions_ROIs = ROIs;
    handles.registered_positions_ROI_handles = ROI_handles;
    
    if print
        msgbox(sprintf('registered %d positions', num_mol));
    end



