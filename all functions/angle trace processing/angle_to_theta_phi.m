function [theta,phi] = angle_to_theta_phi(angle,res_theta,res_phi,num_phi)
    theta = res_theta * floor((angle-1)/num_phi);
    phi = res_phi * mod((angle-1),num_phi);
