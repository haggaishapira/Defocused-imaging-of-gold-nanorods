function handles = plot_gold_3d(handles,plot_info)

    disp_mol = plot_info.disp_mol;
    curr_frame = plot_info.curr_frame;

    pat_theta = disp_mol.theta_half(curr_frame);
    pat_phi = disp_mol.phi_half(curr_frame);

    [x,y,z] = gold_3d(pat_theta,-pat_phi-90);
    set(handles.ax_3d.Children(1),'XData',x,'YData',y,'ZData',z);