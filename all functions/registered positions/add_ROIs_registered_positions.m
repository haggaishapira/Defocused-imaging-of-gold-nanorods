function ROI_handles = add_ROIs_registered_positions(handles,ROIs,visible)
    
    ROI_handles = [];
    num_mol = size(ROIs,1);
    for i=1:num_mol
        ROI = ROIs(i,:);
        ROI_handle = drawrectangle(handles.ax_video,'Position',ROI,'Color',[1 0 0],...
                                'FaceAlpha',0,'LineWidth',0.5,'MarkerSize',1,'Visible',visible);
        ROI_handles = [ROI_handles; ROI_handle];
    end