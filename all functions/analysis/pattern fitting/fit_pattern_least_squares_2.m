function [best_params,lst_sum_sq] = fit_pattern_least_squares_2(frame, patterns, params)

    x = params(1);
    y = params(2);
    focus_ind = params(3);
%     theta_ind = params(4);
%     phi_ind = params(5);

    ROI_im = get_cropped_ROI_im(frame,x,y,focus_ind);

%     num_pat = size(patterns,2);
    lst_sum_sq = inf;
%     angle = 1;
    
    min_theta_ind = 6; 
    
%     start = 1+min_theta/10*72;
%     final_num_pat = num_pat - start + 1;
    
%     sm_sqs = zeros(final_num_pat,1);
    sm_sqs = zeros(10,72);
    counter = 1;
    
%     for i=start:1:num_pat

    best_theta_ind = 0;
    best_phi_ind = 0;

    for theta_ind = min_theta_ind:10
        for phi_ind = 1:72
            pat = squeeze(patterns(focus_ind,theta_ind,phi_ind,:,:));
            sqs = (ROI_im - pat) .^ 2;
            sm_sqs(counter) = sum(sqs(:));
            if sm_sqs(counter) < lst_sum_sq
                lst_sum_sq = sm_sqs(counter);
                best_theta_ind = theta_ind;
                best_phi_ind = phi_ind;
                
            end
            counter = counter + 1;
        end
    end

    best_params = params;
    best_params(4:5) = [best_theta_ind best_phi_ind];






