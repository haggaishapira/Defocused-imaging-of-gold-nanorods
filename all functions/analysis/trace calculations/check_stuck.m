function stuck = check_stuck(phi,d_phi)

    max_d_phi = 100;
    max_range_phi = 60;
    
%     max_range_phi = settings.stuck_max_range;


    stuck = isempty(find(d_phi>max_d_phi,1)) && (max(phi) - min(phi)) <= max_range_phi;


    