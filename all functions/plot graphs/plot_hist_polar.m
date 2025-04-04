function handles = plot_hist_polar(handles,plot_info)    

    if plot_info.num_mol_curr == 0
%         return;
    end

    old_plot_type = plot_info.current_plots{3};
    new_plot_type = plot_info.new_plots{3};

    misc_molecules = plot_info.misc_molecules;
    num_misc_mol = plot_info.num_misc_mol;

    misc_molecule_frames = plot_info.misc_molecule_frames;

    disp_mol = plot_info.disp_mol;
%     curr_mol = plot_info.curr_mol;
%     combine_statistics = plot_info.combine_statistics;


    init_plot = ~strcmp(old_plot_type,new_plot_type);

%     first = plot_info.first;
%     last = plot_info.last;

    switch new_plot_type
        case 'phi'
            phis = get_data_misc_molecules(misc_molecules,num_misc_mol,'trace_phi_whole',misc_molecule_frames);
            vals = phis;
            vals = double(vals);
            vals = mod(vals,360);
            vals = vals*2*pi/360;
%             vals = mod(vals,2*pi);
            title = '\phi';
        case 'phi (180)'
            phis = get_data_misc_molecules(misc_molecules,num_misc_mol,'trace_phi_whole',misc_molecule_frames);
            vals = phis;
            vals = double(vals);
            vals = mod(vals,180);
            vals = vals*2*pi/360;
%             vals = mod(vals,2*pi);
            title = '\phi';
        case 'phi relative to FH12'
%             vals = get_data_misc_molecules(misc_molecules,num_misc_mol,'trace_phi_whole_rel_FH12',misc_molecule_frames);
            vals = get_data_misc_molecules(misc_molecules,num_misc_mol,'trace_phi_whole',misc_molecule_frames,1);
            vals = mod(vals,360);
%             vals = vals + 90;
            vals = mod(vals,180);
%             vals = vals + 90;
%             vals = vals + 180;
            vals = vals*2*pi/360;
            title = '\phi';
        case 'phi around 0'
            phis = get_data_misc_molecules(misc_molecules,num_misc_mol,'trace_phi_whole_around_0',misc_molecule_frames);
            vals = phis;
            vals = mod(vals,360);
            vals = vals*2*pi/360;
            title = '\phi';
        case 'phi with avg (theta)'
            phis = get_data_misc_molecules(misc_molecules,num_misc_mol,'trace_phi_whole',misc_molecule_frames);
            vals = phis;
            vals = double(vals);
            vals = vals*2*pi/360;
            vals = mod(vals,2*pi);
            title = '\phi';
        case 'avg int (phi)'
%             vals = get_data_misc_molecules(misc_molecules,num_misc_mol,'int_by_angle_hist',misc_molecule_frames);
%             vals = disp_mol.int_by_angle_hist;
            vals = disp_mol.int_by_angle;
%             figure
%             bar(0:5:355,vals_2);
%             x_lim = [min(vals) max(vals)];
%             bin_width = 5;
%             x_label = 'sm - fuel response times';
%             x_label = 't (sec)';
            title = 'avg int (phi)';

    end
    if init_plot
        switch new_plot_type
            case 'avg int (phi)'
                cla(handles.ax_hist_polar);
                polarplot(handles.ax_hist_polar,vals);
%                 handles.ax_hist_polar.ThetaZeroLocation = 'Top';
%                 handles.ax_hist_polar.ThetaDir = 'clockwise';
%                 handles.ax_hist_polar.RTick = [];
%                 handles.ax_hist_polar.FontSize = 14;
%                 handles.ax_hist_polar.FontWeight = 'bold';
%                 handles.ax_hist_polar.Title.String = title;
            case 'sm - phi with avg (theta)'
%                 handles.ax_hist_polar.Visible = 'off';
%                 handles.ax_hist_fake_polar.Visible = 'on';
%                 cla(handles.ax_hist_polar);
%                 cla(handles.ax_hist_fake_polar);
%                 handles = plot_fake_polar(handles, vals, theta_avg_per_phi);
            otherwise
                cla(handles.ax_hist_polar);
                handles.ax_hist_polar.Visible = 'on';
%                 cla(handles.ax_hist_fake_polar,'reset');
%                 handles.ax_hist_fake_polar.Visible = 'off';
                polarhistogram(handles.ax_hist_polar,vals,'BinWidth',pi/36);
                handles.ax_hist_polar.ThetaZeroLocation = 'Top';
                handles.ax_hist_polar.ThetaDir = 'clockwise';
                handles.ax_hist_polar.RTick = [];
                handles.ax_hist_polar.FontSize = 14;
                handles.ax_hist_polar.FontWeight = 'bold';
                handles.ax_hist_polar.Title.String = title;
        
        end
    else
    switch new_plot_type
        case 'sm - phi with avg (theta)'
        case 'avg int (phi)'
        otherwise
            set(handles.ax_hist_polar.Children,'Data',vals,'NumBins',72,'BinWidth',pi/36);    
    end

%     cla(handles.ax_hist_fake_polar,'reset');
%     handles = plot_fake_polar(handles, vals, theta_avg_per_phi);
    
    switch new_plot_type
        case 'sm - phi with avg (theta)'
        case 'avg int (phi)'
        otherwise
            counts = handles.ax_hist_polar.Children.Values;
%             handles.ax_hist_polar.RLim = [0 max(3,max(counts))];
    end
    end

    










