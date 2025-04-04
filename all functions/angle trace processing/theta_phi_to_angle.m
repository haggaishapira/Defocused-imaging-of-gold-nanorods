function [angle] = theta_phi_to_angle(angle,res_theta,res_phi,num_phi)
    angle = (theta/res_theta) * num_phi + (phi/res_phi) + 1;
