function out_of_bounds = ROI_out_of_bounds(analysis_settings,ROI)

    x = ROI(1);
    y = ROI(2);
    ROI_dim = ROI(3);
    rad = (ROI_dim-1)/2;
    center_x = x+rad;
    center_y = y+rad;
    
    dist_x_left = analysis_settings.dist_x_left;
    dist_y_top = analysis_settings.dist_y_top;
    dist_x_right = analysis_settings.dist_x_right;
    dist_y_bottom = analysis_settings.dist_y_bottom;

    if center_x<=dist_x_left || center_x>512-dist_x_right || center_y<=dist_y_top || center_y+ROI_dim-1>512-dist_y_bottom 
        out_of_bounds = 1;
    else
        out_of_bounds = 0;
    end
