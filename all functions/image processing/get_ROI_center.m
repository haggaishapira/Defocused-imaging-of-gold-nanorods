function [center_x,center_y] = get_ROI_center(ROI)
    
    center_x = (ROI(1) + ROI(3))/2;
    center_y = (ROI(2) + ROI(4))/2;