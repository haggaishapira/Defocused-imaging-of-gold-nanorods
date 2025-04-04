function too_close = molecule_too_close(new_ROI,existing_ROIs,num_added_mol)

    [new_center_x,new_center_y] = get_ROI_center(new_ROI);

    new_ROI_dim = new_ROI(3);
    

    too_close = 0;  
    for j=1:num_added_mol
        existing_ROI = existing_ROIs(j,:);
        [existing_center_x,existing_center_y] = get_ROI_center(existing_ROI);
        existing_ROI_dim = existing_ROI(3);
        min_dist = max(new_ROI_dim,existing_ROI_dim) * 0.2;
        d = ((new_center_x-existing_center_x)^2 + (new_center_y-existing_center_y)^2) ^ 0.5;
        if d < min_dist %too close to another molecule
            too_close = 1;
            break;
        end
    end