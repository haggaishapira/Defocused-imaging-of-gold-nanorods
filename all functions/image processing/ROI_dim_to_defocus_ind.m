function defocus_ind = ROI_dim_to_defocus_ind(handles,ROI_dim)
    nn = (ROI_dim-1)/2;
    % nn is the pattern square image "radius" in the original pattern software jargon
    % nn is in range 8-12
    
    min_nn = min(handles.nn_array);
    defocus_ind = nn-min_nn+1;
