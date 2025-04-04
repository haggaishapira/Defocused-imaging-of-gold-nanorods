function patterns = get_patterns(handles,defocus_ind,matrix,flat)

    settings = handles.pattern_fitting_settings;
    res_theta = settings.res_theta;
    res_phi = settings.res_phi;

    patterns = handles.patterns{defocus_ind};
    ROI_dim = size(patterns,3);


    num_theta = 90/res_theta + 1;
    num_phi = 360/res_phi;

    if matrix
        if flat
            patterns = reshape(patterns,[num_theta num_phi ROI_dim*ROI_dim]);
        end
    else
        patterns = permute(patterns,[2 1 3 4]);
        patterns = reshape(patterns,[num_theta*num_phi ROI_dim ROI_dim]);
        if flat
            patterns = reshape(patterns,[num_theta*num_phi ROI_dim*ROI_dim]);
        end
    end
    











