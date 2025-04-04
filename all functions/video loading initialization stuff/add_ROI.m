function ROI_handle = add_ROI(handles,ROI)

    ROI_handle = drawrectangle(handles.ax_video,'Position',ROI,'Color',[1 1 1],'FaceAlpha',0,'LineWidth',0.5,'MarkerSize',1);
%     ROI_handle = drawrectangle(handles.ax_video,'Position',ROI,'Color',[1 1 1],'FaceAlpha',0,'LineWidth',0.5);

