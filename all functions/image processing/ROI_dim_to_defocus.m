function defocus = ROI_dim_to_defocus(ROI_dim)
%     min_nn = min(handles.nn_array);
%     defocus_array = get_defocus_array(handles);
%     nn = (ROI_dim-1)/2;
%     ind = nn-min_nn+1;
%     defocus = defocus_array(ind);

    nn = ROI_dim/2-1;
    defocus = nn / (-10);