function handles = update_fitting_pattern(handles,plot_info)

    disp_mol = plot_info.disp_mol;
    curr_frame = plot_info.curr_frame;

    pat_theta = disp_mol.theta_half(curr_frame);
    pat_phi = disp_mol.phi_half(curr_frame);

%     ROI = disp_mol.ROI(curr_frame,:);
%     ROI_dim = ROI(3);

    defocus_ind = round(disp_mol.defocus(curr_frame)*-10) + 1;
%     defocus_ind = 3;
%     defocus_ind = ROI_dim_to_defocus_ind(handles,ROI_dim);


    fitting_pattern = get_pattern(handles,pat_theta,pat_phi,defocus_ind,0);

    default_dim = 29;
%     default_im = zeros(default_dim,default_dim);
%     start = (default_dim - ROI_dim)/2 + 1;
%     default_im(start:start+ROI_dim-1,start:start+ROI_dim-1) = fitting_pattern;


    handles.ax_fitting_pattern.Children.CData = fitting_pattern;
    handles.ax_fitting_pattern.XTick = [];
    handles.ax_fitting_pattern.YTick = [];
%     sz = size(fitting_pattern,1);
    handles.ax_fitting_pattern.XLim = [0.5 default_dim + 0.5];
    handles.ax_fitting_pattern.YLim = [0.5 default_dim + 0.5];







