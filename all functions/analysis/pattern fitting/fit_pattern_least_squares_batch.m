function [angles,min_sqs] = fit_pattern_least_squares_batch(ROIs,patterns_gpu,num_pat,min_theta)
    
    num_ROIs = size(ROIs,2);
    
    sum_sqs = gpuArray(inf*ones(num_pat,num_ROIs));
    start = 1+min_theta/10*72;
    for n=start:num_pat
        sqs = (patterns_gpu(:,(n-1)*num_ROIs+1:n*num_ROIs)-ROIs).^2;
        sum_sqs(n,:) = sum(sqs,1);
    end

    [min_sqs,angles] = min(sum_sqs);
    angles = gather(angles);
%     toc

