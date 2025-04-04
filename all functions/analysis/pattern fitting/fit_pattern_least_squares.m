function [theta,phi,lst_sum_sq] = fit_pattern_least_squares(ROI_image, patterns)
    num_pat = size(patterns,2);
    lst_sum_sq = inf;
    angle = 1;
    
    min_theta = 50; 
    
    start = 1+min_theta/10*72;
    final_num_pat = num_pat - start + 1;
    
    sm_sqs = zeros(final_num_pat,1);
    counter = 1;
    
    for i=start:1:num_pat
        sqs = (ROI_image - patterns(:,i)) .^ 2;
        sm_sqs(counter) = sum(sqs(:));
        if sm_sqs(counter) < lst_sum_sq
            lst_sum_sq = sm_sqs(counter);
            angle = i;
        end
        counter = counter + 1;
    end
    [theta,phi] = angle_to_theta_phi(angle,10,5,72);
