function [mu,sigma] = fit_state_with_180_jumps(phi)

    % centralize peak around 90
    phi = mod(phi,180);
    
%     md = mode(phi);
%     phi = phi - md + 90;
    phi = phi + 90;
    phi = mod(phi,180);

    [mu,sigma] = calculate_phi_gaussian_fit(phi);

    % back to original
    mu = mod(mu-90,180);

    
    