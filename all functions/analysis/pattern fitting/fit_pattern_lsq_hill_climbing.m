function [theta, phi, lst_sq] = fit_pattern_lsq_hill_climbing(patterns, ROI_image,ROI_dim)

    phis_to_try = 1:9:72;
    theta_ind = 7;
    lst_sm_sq = inf;
    best_phi_ind = 1;
%     dim_sq = size(ROI_image,1);


    for i=1:length(phis_to_try)  
        phi_ind = phis_to_try(i);
        pat = squeeze(patterns(theta_ind,phi_ind,:));
        sqs = (ROI_image - pat) .^ 2;    
        current_sum_sqs = sum(sqs(:));
        if current_sum_sqs<lst_sm_sq
            lst_sm_sq = current_sum_sqs;
            best_phi_ind = phi_ind;
        end
    end
    phi_ind = best_phi_ind;
    
%     pat = squeeze(patterns(theta_ind,phi_ind,:));
%     sqs = (ROI_image - pat) .^ 2;    
    current_sum_sqs = lst_sm_sq;
    delta_max = 1;
    
%     counter = 0;
    while delta_max>0
        delta_max = -inf;
        %try 4 directions
        thetas_to_try = [theta_ind+1 theta_ind theta_ind theta_ind-1];
        phis_to_try = [phi_ind phi_ind+1 phi_ind-1 phi_ind];
        temp_best_sum_sqs = current_sum_sqs;
        for i=1:4
            if thetas_to_try(i)<6 || thetas_to_try(i)>10 || ...
                    phis_to_try(i)<1 || phis_to_try(i)>72
                continue 
            else
%                 counter = counter + 1;
            end
            pat = squeeze(patterns(thetas_to_try(i),phis_to_try(i),:));
            sqs = (ROI_image - pat) .^ 2;
            sm_sqs = sum(sqs(:));
            delta = - (sm_sqs - current_sum_sqs);
            if delta > delta_max
                delta_max = delta;
                temp_best_sum_sqs = sm_sqs;
                theta_ind =  thetas_to_try(i);
                phi_ind =  phis_to_try(i);
            end
        end
        current_sum_sqs = temp_best_sum_sqs;
    end
    theta = (theta_ind-1)*10;
    phi = (phi_ind-1)*5;
    
    pat = squeeze(patterns(theta_ind,phi_ind,:));
    pat = reshape(pat,ROI_dim,ROI_dim);
%     disp(counter);
    lst_sq = current_sum_sqs;
    
    
    
    