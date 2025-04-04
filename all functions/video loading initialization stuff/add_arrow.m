function [arrow_main,arrow_right,arrow_left] = add_arrow(handles,molecule,color, use_initial_ROI,visible)
%     t1 = toc;
    current_frame = round(handles.slider_frames.Value);
%     ROI = handles.molecules(mol).ROI(:,current_frame);
    
    if use_initial_ROI
        ROI = molecule.initial_ROI;
    else
        ROI = molecule.ROI(current_frame,:);
    end

%     switch handles.analysis_version.Value
%         case 1
%             phi = handles.molecules(mol).trace_phi_whole(current_frame);
%         case 2
%             phi = handles.molecules(mol).trace_phi_half(current_frame);
%         case 3
%             phi = handles.molecules(mol).phi_half(current_frame);
%     end               
%     phi = handles.molecules(mol).trace_phi_whole(current_frame);
    phi = molecule.phi_whole(current_frame);
    

    XLim = handles.ax_video.XLim;
    YLim = handles.ax_video.YLim;
    pos = handles.ax_video.Position;

    arrow_width = 1.5;

    [x_main,y_main,x_right,y_right,x_left,y_left] = get_arrow_coordinates(ROI,phi,pos,XLim,YLim);
    hold(handles.ax_video,'on');
    arrow_main = line(handles.ax_video,x_main,y_main,'Color',color,'LineWidth',arrow_width,'Visible',visible);
    hold(handles.ax_video,'on');
    arrow_right = line(handles.ax_video,x_right,y_right,'Color',color,'LineWidth',arrow_width,'Visible',visible);
    hold(handles.ax_video,'on');
    arrow_left = line(handles.ax_video,x_left,y_left,'Color',color,'LineWidth',arrow_width,'Visible',visible);







    