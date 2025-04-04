function [next_theta,next_phi] = half_sphere_to_whole(prev_theta,prev_phi,next_theta1,next_phi1)
    prev_theta = double(prev_theta);
    prev_phi = double(prev_phi);
    next_theta1 = double(next_theta1);
    next_phi1 = double(next_phi1);

    next_theta2 = 180-next_theta1;
    next_phi2 = mod(next_phi1+180,360);
    if next_theta1 <= 0 
        next_phi1 = prev_phi;
        next_phi2 = prev_phi;
    end
    factor = 2*pi/360;
    x_prev = cos(prev_phi*factor)*sin(prev_theta*factor);
    x_next1 = cos(next_phi1*factor)*sin(next_theta1*factor);
    x_next2 = cos(next_phi2*factor)*sin(next_theta2*factor);
    y_prev = sin(prev_phi*factor)*sin(prev_theta*factor);
    y_next1 = sin(next_phi1*factor)*sin(next_theta1*factor);
    y_next2 = sin(next_phi2*factor)*sin(next_theta2*factor);
    z_prev = cos(prev_theta*factor);
    z_next1 = cos(next_theta1*factor);
    z_next2 = cos(next_theta2*factor);
    d1 = (x_prev-x_next1)^2 + (y_prev-y_next1)^2 + (z_prev-z_next1)^2; 
    d2 = (x_prev-x_next2)^2 + (y_prev-y_next2)^2 + (z_prev-z_next2)^2;
    if d1>d2
        next_theta = next_theta2;
        next_phi = next_phi2;
    else
        next_theta = next_theta1;
        next_phi = next_phi1;
    end
