function data = get_sm_data(molecule,type_name,first,last)

    switch type_name
        case 'sm - trace phi whole'            
            data = molecule.trace_phi_whole;
        case 'sm - d(phi)'
            data = molecule.d_phi(first:last);
        case 'sm - phi half'
            data = molecule.phi_half(first:last);  
        case 'sm - theta whole'
            data = molecule.theta_whole(first:last);            
        case 'sm - intensity'
            data = molecule.back(first:last) + molecule.int(first:last);
        case 'sm - defocus'
            data = molecule.defocus(first:last);
        case 'sm - x'
            data = molecule.x(first:last);
        case 'sm - y'
            data = molecule.y(first:last);
        case 'sm - lst sq error'
            data = molecule.lst_sq_video(first:last);
    end