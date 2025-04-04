function molecule = calc_int_as_func_of_phi(molecule, vid_len)

    counts = zeros(72,1);
    for i=1:vid_len
        phi_half = molecule.phi_half(i);
        phi_half_ind = phi_half/5 + 1;
        int = molecule.int(i);
        
        % regular method
        molecule.int_by_angle(phi_half_ind) = molecule.int_by_angle(phi_half_ind) + int;
        counts(phi_half_ind) = counts(phi_half_ind) + 1;
        
        % weird hist method
%             small_int = round(int / (10^5));
%             molecule.int_by_angle_hist = [molecule.int_by_angle; phi_half*ones(small_int,1,'int16')];
    end
    for i=1:72
        molecule.int_by_angle(i) = molecule.int_by_angle(i) / counts(i); 
    end