function [pass,defocus_ind,theta_ind,phi_ind] = pattern_matching_filter(frame,collapse,patterns,rings,x,y,defocus_ind)

    nn = 14;
    try
        ROI_image = frame(y-nn:y+nn,x-nn:x+nn);
    catch e
        1;
    end
    params_init = [x y defocus_ind 8 1];
    params_to_opt = 1:5;
    max_dist = 3;
    fit_rings = 0;


% (full_im, patterns, params_init,calibration,x_start,y_start, rings, collapse, fit_xy, params_to_opt, max_dist)

        [fit_params,error] = fit_pattern_lsq_gradient_descent...
                                            (frame, patterns, params_init,1,x,y, ...
                                                rings, frame, 1, 1:5 ,max_dist,7,0,15);

%     [fit_params,error] = fit_pattern_lsq_gradient_descent...
%                         (frame, patterns, params_init, params_to_opt,x,y, rings, collapse, fit_rings, max_dist);

    defocus_ind = fit_params(3);
    theta_ind = fit_params(4);
    phi_ind = fit_params(5);

    if error < 0.001
        pass = 1;
    else
        pass = 0;
    end




