function ROI_dim = defocus_ind_to_ROI_dim(handles,defocus_ind)
    
    nn_array = handles.nn_array;
    rad = nn_array(defocus_ind);
    ROI_dim = 2*rad + 1;

