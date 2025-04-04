function [best_params,curr_error] = fit_pattern_lsq_gradient_descent(full_im, patterns, params_init,calibration,x_start,y_start, rings, collapse,...
                                                                    fit_xy_single_molecule, params_to_opt, max_dist, min_theta_ind,transform,...
                                                                    max_defocus_ind)

% (frame, handles.patterns, current_params,x_initial,y_initial, ...
%                                                 rings, collapse, fit_z, fit_xy, max_dist)
    
    curr_params = params_init;
    defocus = curr_params(3);
    dim_vid = size(full_im,1);

    if ~calibration
        x_start = curr_params(1);
        y_start = curr_params(2);
    end
    % find x,y position by ring fitting 
    if fit_xy_single_molecule
        ring = rings(:,:,defocus);
        curr_pos = curr_params(1:2);

        best_pos = curr_pos;
        curr_fitting = calculate_ring_fitting(collapse,ring,curr_pos(1),curr_pos(2));
        dirs = [1 0; 0 1; -1 0; 0 -1];
        can_optimize = 1;
        while can_optimize
            for i=1:size(dirs,1)
                dir = dirs(i,:);
                pos_try = curr_pos + dir;
                x = pos_try(1);
                y = pos_try(2);
                if y-14<1 || y+14>dim_vid || x-14<1 || x+14>dim_vid || abs(y-y_start)>max_dist || abs(x-x_start)>max_dist
                   continue;
                end
                fitting_try = calculate_ring_fitting(collapse,ring,pos_try(1),pos_try(2));            
                if fitting_try > curr_fitting
                    curr_fitting = fitting_try;
                    best_pos = pos_try;
%                     disp('ring fitting improvement');
                end                    
            end
            if isequal(curr_pos,best_pos)
                can_optimize = 0;
                curr_params(1:2) = best_pos;
            else
                curr_pos = best_pos;
            end
        end
    end
    
    % find phi roughly
    theta_ind = curr_params(4);
%     phi_ind = curr_params(5);
    lst_sm_sq = inf;
    best_phi_ind = 1;
    phis_to_try = 1:9:72;
    defocus = curr_params(3);
    x = curr_params(1);
    y = curr_params(2);

    ROI_im = get_cropped_ROI_im(full_im,x,y,defocus,transform);
    for i=1:length(phis_to_try)  
        phi_ind = phis_to_try(i);
        pattern = get_cropped_pattern(patterns,defocus,theta_ind,phi_ind);
        sqs = (ROI_im - pattern) .^ 2;    
        current_sum_sqs = sum(sqs(:));
        if current_sum_sqs<lst_sm_sq
            lst_sm_sq = current_sum_sqs;
            best_phi_ind = phi_ind;
        end
    end
    curr_params(5) = best_phi_ind;

    curr_error = calculate_error(full_im,patterns,curr_params,x_start,y_start, max_dist, min_theta_ind,transform,max_defocus_ind);
    best_params = curr_params;

    % search for minimum of focus theta and phi
    can_optimize = 1;
    while can_optimize
        for param = params_to_opt
            params_try_up = curr_params;
            params_try_up(param) = params_try_up(param) + 1;
            % correct circularity of phi
            if param == 5 && params_try_up(param)>72
                params_try_up(param) = 1;
            end
            error_try_up = calculate_error(full_im,patterns,params_try_up,x_start,y_start, max_dist,min_theta_ind,transform,max_defocus_ind);
            params_try_down = curr_params;
            params_try_down(param) = params_try_down(param) - 1;
            % correct circularity of phi
            if param == 5 && params_try_down(param)<1
                params_try_down(param) = 72;
            end

            error_try_down = calculate_error(full_im,patterns,params_try_down,x_start,y_start, max_dist,min_theta_ind,transform,max_defocus_ind);

            min_errors = min(error_try_down,error_try_up);
            if min_errors < curr_error
                curr_error = min_errors;
                if error_try_down<error_try_up
                    best_params = params_try_down;
                else
                    best_params = params_try_up;
                end
            end                    
        end
        if isequal(curr_params,best_params)
            can_optimize = 0;
        else
            curr_params = best_params;
        end
    end

     % optimize theta
%     for theta_ind_try=6:10
%         params_try = curr_params;
%         params_try(4) = theta_ind_try;
%         error = calculate_error(full_im,patterns,params_try,x_start,y_start, max_dist);
%         if error<curr_error
%             curr_error = error;
%             best_params = params_try;
%         end
%     end









    





