function molecules = add_basic_molecule_info(molecules)
    
    for i=1:num_mol
%         molecules(i).ROI(:,1) = ROIs(:,i);
%         molecules(i).lst_sq_find = lst_sqs(i);
%         molecules(i).num = i;
        molecules(i).str = sprintf('molecule %d',i);

        y = ROIs(2,i);
        x = ROIs(1,i);
        dim = ROIs(3,i);
        center_x = x+(dim-1)/2;
        center_y = y+(dim-1)/2;
        defocus_ind = 1;
        theta_ind = 7;
        phi_ind = 1;
        molecules(i).params_init = [center_y center_x defocus_ind theta_ind phi_ind]; 
    end