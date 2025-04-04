function set_current_defocus_ind(current_nn)

    ROI_dim = 2*nn + 1;
    handles.current_defocus_ind = ROI_dim_to_defocus_ind(handles,ROI_dim)