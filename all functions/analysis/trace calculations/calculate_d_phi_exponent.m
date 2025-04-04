function mu = calculate_d_phi_exponent(d_phi,ax_fitting)

    try
        [~,dist_object] = my_histfit(ax_fitting,d_phi,20,'exponential');
        mu = dist_object.mu;
%         molecule.d_phi_exponent_fitting_mu = dist_object.mu;
    catch e
%         molecule.d_phi_exponent_fitting_mu = 0;
        mu = 0;
    end