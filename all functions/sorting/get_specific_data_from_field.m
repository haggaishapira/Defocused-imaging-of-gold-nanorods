function data = get_specific_data_from_field(molecules,field_str,curr_frame)

    switch field_str
        case 'num'
            data = cell2mat({molecules.num});
        case 'x'
            data = cell2mat({molecules.x});
            data = data(curr_frame,:);
        case 'y'
            data = cell2mat({molecules.y});
            data = data(curr_frame,:);
        case 'defocus'
            data = cell2mat({molecules.defocus});
            data = data(curr_frame,:);
        case 'theta'
            data = cell2mat({molecules.theta_whole});
            data = data(curr_frame,:);
        case 'phi_half'
            data = cell2mat({molecules.phi_half});
            data = data(curr_frame,:);
        case 'phi dist sigma'
            data = cell2mat({molecules.phi_dist_sigma});
        case 'dissociation_time'
            data = cell2mat({molecules.dissociation_time});
        case 'release_time'
            data = cell2mat({molecules.release_time});
        case 'immobilization_time'
            data = cell2mat({molecules.immobilization_time});
        case 'preferred_phi'
            data = cell2mat({molecules.preferred_phi});
        case 'pref_phi_rel'
            data = cell2mat({molecules.pref_phi_rel});
        case 'span'
            data = cell2mat({molecules.span});
        case 'int'
            data = cell2mat({molecules.int});
            data = data(curr_frame,:);
        case 'back'
            data = cell2mat({molecules.int});
            data = data(curr_frame,:);
        case 'lst_sq_find'
            data = cell2mat({molecules.lst_sq_find});
        case 'lst_sq_video'
            data = cell2mat({molecules.lst_sq_video});
            data = data(curr_frame,:);
        case 'S2N'
            data = cell2mat({molecules.lst_sq_video});
            data = data(curr_frame,:);
        case 'deviation_from_free_rotation'
            data = cell2mat({molecules.deviation_from_free_rotation});
    end



