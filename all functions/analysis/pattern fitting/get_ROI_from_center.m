function ROI = get_ROI_from_center(center_x,center_y,rad)

    left = center_x - rad;
    top = center_y - rad;
    right = center_x + rad;
    bottom = center_y + rad;

    width = right - left + 1;
    height = bottom - top + 1;
    ROI = [left top width height];
    
%     ROI_im = frame(left:right,top:bottom);