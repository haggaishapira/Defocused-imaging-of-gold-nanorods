function temp_molecule = process_and_save_angle_info(frame_num,molecule,theta,phi, temp_molecule)

    i = frame_num;
    temp_molecule.theta_half = theta;
    temp_molecule.phi_half = phi;
    if i == 1
%         molecule.theta_whole(1) = molecule.theta_half(1);
%         molecule.phi_whole(1) = molecule.phi_half(1);
%         molecule.trace_theta_half(1) = molecule.theta_half(1);
%         molecule.trace_phi_half(1) = molecule.phi_half(1);
%         molecule.trace_theta_whole(1) = molecule.theta_half(1);
%         molecule.trace_phi_whole(1) = molecule.phi_half(1);
%         molecule.trace_phi_whole(1) = molecule.phi_half(1);

        temp_molecule.theta_whole = temp_molecule.theta_half;
        temp_molecule.phi_whole = temp_molecule.phi_half;
        temp_molecule.trace_theta_half = temp_molecule.theta_half;
        temp_molecule.trace_phi_half = temp_molecule.phi_half;
        temp_molecule.trace_theta_whole = temp_molecule.theta_half;
        temp_molecule.trace_phi_whole = temp_molecule.phi_half;

        temp_molecule.d_phi = 0;
        temp_molecule.d_theta = 0;
    else
        prev_theta_whole = molecule.theta_whole(i-1);
        prev_phi_half = molecule.phi_half(i-1);
        prev_phi_whole = molecule.phi_whole(i-1);
        next_theta_half = temp_molecule.theta_half;
        next_phi_half = temp_molecule.phi_half;
        [next_theta_whole,next_phi_whole] = ...
            half_sphere_to_whole(prev_theta_whole,prev_phi_whole,next_theta_half,next_phi_half);

        temp_molecule.theta_whole = next_theta_whole;
        temp_molecule.trace_theta_half = temp_molecule.theta_half;
        temp_molecule.trace_theta_whole = temp_molecule.theta_whole;
        temp_molecule.phi_whole = next_phi_whole; 
        delta_phi_half = get_delta_phi(prev_phi_half,next_phi_half);
        delta_phi_whole = get_delta_phi(prev_phi_whole,next_phi_whole);
        temp_molecule.trace_phi_half = molecule.trace_phi_half(i-1) + delta_phi_half;
        temp_molecule.trace_phi_whole = molecule.trace_phi_whole(i-1) + delta_phi_whole;
        temp_molecule.d_phi = abs(delta_phi_whole);
        temp_molecule.d_theta = abs(next_theta_whole-prev_theta_whole);
    end
    


    