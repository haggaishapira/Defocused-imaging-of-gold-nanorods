function [x_main,y_main,x_right,y_right,x_left,y_left] = get_arrow_coordinates(ROI,phi,~,XLim,YLim)
% function [X,Y] = get_arrow_coordinates(ROI,phi,ax_pos,XLim,YLim)

    % special arrow

    x1 = (2*ROI(1)+ROI(3)) / 2 - 1;
    y1 = (2*ROI(2)+ROI(4)) / 2 - 1;
    rad = ROI(3)/2-3;
    rad_sides = rad * 0.5;

    % reverse direction and start from top
    phi = -phi+90;
    
    phi_rad = double(phi)*2*pi/360;
    x2 = x1 + rad * cos(phi_rad);
    y2 = y1 - rad * sin(phi_rad);
    x_main = [x1 x2];
    y_main = [y1 y2];
    
    shift_rad = rad/50;
    x1_right = x2 + shift_rad*cos(phi_rad+pi/2);
    y1_right = y2 + shift_rad*sin(phi_rad+pi/2);
    angle_right = phi_rad+pi+pi/6;
    x2_right = x2 + rad_sides * cos(angle_right);
    y2_right = y2 - rad_sides * sin(angle_right);
    x_right = [x1_right x2_right];
    y_right = [y1_right y2_right];
    
    x1_left = x2 + shift_rad*cos(phi_rad-pi/2);
    y1_left = y2 + shift_rad*sin(phi_rad-pi/2);
    angle_left = phi_rad+pi-pi/6;
    x2_left = x2 + rad_sides * cos(angle_left);
    y2_left = y2 - rad_sides * sin(angle_left);
    x_left = [x1_left x2_left];
    y_left = [y1_left y2_left];
    all_x = [x_main x_right x_left];
    all_y = [y_main y_right y_left];
    
    % check if exceeds limits
    try
        if ~isempty(find(all_x<XLim(1) | all_x>XLim(2))) ||  ~isempty(find(all_y<YLim(1) | all_y>YLim(2)))
            x_main = -1;
            y_main = -1;
            x_right = -1;
            y_right = -1;
            x_left = -1;
            y_left = -1;
            return;
        end
    catch e
        1
    end


%     % original arrow
%     x1 = (2*ROI(1)+ROI(3)) / 2 - 1;
%     y1 = (2*ROI(2)+ROI(4)) / 2 - 1;
%     rad = ROI(3)/2-3;
% 
%     % reverse direction and start from top
%     phi = -phi+90;    
%     phi_rad = double(phi)*2*pi/360;
%     x2 = x1 + rad * cos(phi_rad);
%     y2 = y1 - rad * sin(phi_rad);
% 
%     X = [x1 x2];
%     Y = [y1 y2];
% 
%     % normalize to fig location
% %     f_pos = handles.ax_video.Position;
%     X = ax_pos(1) + ax_pos(3) * X;
%     Y = ax_pos(2) + ax_pos(4) * Y;


