function [mu,sigma] = calculate_phi_gaussian_fit(phi)

    [mu,sigma] = normfit(phi);
    
%     disp(sigma);

    if sigma > 30
        mu = mode(phi);
%         sigma = -1;
    end