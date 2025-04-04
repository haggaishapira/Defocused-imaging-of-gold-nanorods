function [error] = calculate_error(full_im,patterns,params,y_start,x_start, max_dist,min_theta_ind,transform,max_defocus_ind)

    dim_vid = size(full_im,1);
    try
        y = params(1);
        x = params(2);
        defocus = params(3);
        theta = params(4);
        phi = params(5);
    catch e
        1;
    end
%     min_theta_ind = size(params,4);
%     max_theta_ind = size(patterns,2);

% need this for defocusing in initial recording of area!
    min_defocus_ind = 1;  
    max_defocus_ind = 14;
    % use this only when area is already registered
%     min_defocus_ind = 8;  
%     max_defocus_ind = 13;


    max_theta_ind = size(patterns,2);
    max_phi_ind = size(patterns,3);
%     min_theta_ind = 8;
    if y-14<1 || y+14>dim_vid || x-14<1 || x+14>dim_vid || abs(y-y_start)>max_dist || abs(x-x_start)>max_dist || defocus<min_defocus_ind|| defocus>max_defocus_ind ||...
            theta<min_theta_ind || theta>max_theta_ind || phi<1 || phi>max_phi_ind
        error = inf;
        ROI_im = [];
        return;
    end
       
    ROI_im = get_cropped_ROI_im(full_im,y,x,defocus,transform);
    pattern = get_cropped_pattern(patterns,defocus,theta,phi);

%     1;


    sqs = (pattern - ROI_im) .^ 2;
    error = sum(sqs(:));





