function handles = plot_hist_linear(handles,plot_info)    

    if plot_info.num_mol_curr == 0
%         return;
    end

    old_plot_type = plot_info.current_plots{4};
    new_plot_type = plot_info.new_plots{4};
    disp_mol = plot_info.disp_mol;

    init_plot = ~strcmp(old_plot_type,new_plot_type);

    misc_molecules = plot_info.misc_molecules;
    num_misc_mol = plot_info.num_misc_mol;
    misc_molecule_frames = plot_info.misc_molecule_frames;

    first_frame = plot_info.first_frame;
    last_frame = plot_info.last_frame;
    first_t = plot_info.first_t;
    last_t = plot_info.last_t;
    
    plot_gauss_fitting = 0;

%     lims_step_times = [-10 800];
    lims_step_times = [-10 600];
%     lims_step_sizes = [0 60];
    lims_step_sizes = [-20 100];
    max_lim_release_times = 400;
    lims_immobilization_times = [0 900];

    % bin width
    step_size_bin_width = 8;

    settings = handles.extra_calculations_settings;


    switch new_plot_type
        case 'phi'   
%             phi = get_data_misc_molecules(misc_molecules,num_misc_mol,'trace_phi_whole',misc_molecule_frames);
            phi = get_data_misc_molecules(misc_molecules,num_misc_mol,'phi_half',misc_molecule_frames);
%             phi = smooth(phi,100);
            phi = mod(phi,360);
            vals = phi;
            bin_width = 10;
            x_lim = [0 360];
%             x_lim = [65 115];   
            x_label = '\phi';
        case 'phi (180)'   
            phi = get_data_misc_molecules(misc_molecules,num_misc_mol,'trace_phi_whole',misc_molecule_frames);
            phi = mod(phi,180);
            vals = phi;
            bin_width = 5;
            x_lim = [0 180];
            x_label = '\phi';
        case 'phi relative to FH12'   
%             vals = get_data_misc_molecules(misc_molecules,num_misc_mol,'trace_phi_whole_rel_FH12',misc_molecule_frames);
            vals = get_data_misc_molecules(misc_molecules,num_misc_mol,'trace_phi_whole',misc_molecule_frames,1);
%             vals = mod(vals,360);
%             vals = vals + 90;
            vals = mod(vals,180);
%             vals = vals + 1;
%             vals = vals + 90;
%             vals = vals + 360 ;
%             vals = sort(vals);
            bin_width = 5;
%             disp(vals);
            x_lim = [0 180];
%             x_lim = [90 270];
%             x_lim = [-90 90];
            x_tick = 0:30:180;
%             x_label = '\phi relative to FH12';
            x_label = '\phi';

        case 'phi around 0'   
            vals = get_data_misc_molecules(misc_molecules,num_misc_mol,'trace_phi_whole_around_0',misc_molecule_frames);
            vals = vals + 180;
            vals = mod(vals,360);
            vals = vals - 180;
            vals(abs(vals)>40) = 0;
            bin_width = 3;
%             x_lim = [0 360];
            x_lim = [-20 20];
            x_label = '\phi around 0';

            % if single molecule
            val = handles.choose_sm_or_ens.Value;
            sm_or_ens = handles.choose_sm_or_ens.String{val};
            if strcmp(sm_or_ens,'single molecule')
                % plot fitting
%                 mu = disp_mol.phi_dist_mu;
                mu = 0;
                sigma = disp_mol.phi_dist_sigma;
                x_gauss = -30:0.1:30;
                y_gauss = exp( - ((x_gauss).^2/(2*sigma^2) )) / (sigma * (2*pi)^0.5); 
                plot_gauss_fitting = 1;

            end

        case 'dwell times'   
            dwells = get_data_simple(misc_molecules,'dwells');
            dwell_times = dwells(1,:);
            dwell_start_times = dwells(2,:);
            dwell_end_times = dwells(3,:);
            filtered_dwell_times = dwell_times(find(dwell_start_times > first_t & dwell_end_times < last_t));
            vals = filtered_dwell_times;
            bin_width = 1;
            vals(vals<1) = [];
%             x_lim = [0 max(vals)];
            x_lim = [0 100];            
            x_label = 'dwell times';
%             disp(max(vals));
        case 'theta'
            vals = disp_mol.theta_whole;
%             x_lim = [min(vals) max(vals)];
            bin_width = 10;
%             x_label = 'sm - fuel step times';
            x_label = 't (sec)';
        case 'avg int (phi)'
            vals = get_data_simple(misc_molecules, 'int_by_angle');
            vals(isnan(vals)) = 0;
            vals = sum(vals,2);
%             x_lim = [min(vals) max(vals)];
            bin_width = 5;
%             x_label = 'sm - fuel step times';
            x_label = 't (sec)';
        case 'defocus'   
            vals = disp_mol.trace_phi_whole(first_frame:last_frame);
            vals = vals - disp_mol.initial_state_phi;
            vals = mod(vals,360);
            bin_width = 5;
            x_lim = [0 360];
            x_label = 'sm - \phi relative to initial state';
%             x_label = 'relative \phi';
        case 'molecule intensity'   
            vals = disp_mol.trace_phi_whole(first_frame:last_frame);
            vals = vals - disp_mol.final_state_phi;
            vals = mod(vals,360);
            bin_width = 5;
            x_lim = [0 360];
%             y_label = 'sm - relative \phi (whole movie)';
            x_label = 'sm - \phi relative to final state';
        case 'pixel intensity'
            vals = disp_mol.d_phi(first_frame:last_frame,:);
            x_lim = [0 180];
            x_tick = 0:30:180;
            bin_width = 5;
            y_label = '% stuck';
            x_label = 'sm - d(phi) (all)';
%             x_label = 'sm - d(phi) (all)';
        case 'deviation from free rotation'
            vals = get_data_simple(misc_molecules, 'deviation_from_free_rotation');
%             y_label = 'deviation from free rotation';
            x_lim = [0 1];
%             x_tick = 0:90:180;
            bin_width = 0.01;  
            x_label = 'phi';
        case 'd(phi) - exponent fitting'   
            vals = get_data_simple(misc_molecules, 'd_phi_exponent_fitting_mu');
%             y_label = 'deviation from free rotation';
            x_lim = [0 60];
%             x_tick = 0:90:180;
            bin_width = 1;  
            x_label = 'phi';
        case 'phi distribution mu' 
            vals = get_data_simple(misc_molecules, 'phi_dist_mu');
            FH12_pos = get_data_simple(misc_molecules, 'FH12_position');
            vals = vals - FH12_pos;
            vals = mod(vals,180);
            x_label = 'phi dist mu';
%             bin_width = 0.5;
            bin_width = 2;
            x_lim = [0 180];
        case 'phi distribution sigma' 
            vals = get_data_simple(misc_molecules, 'phi_dist_sigma');
%             vals = mod(vals,180);
            x_label = 'phi dist sigma';
%             bin_width = 0.5;
            bin_width = 1;
            x_lim = [0 20];
            x_tick = 0:2:20;

%             f=figure;
%             f.Position(2) = 0.6*f.Position(2);
%             ax = axes(f);
%             sigma = get_data_simple(misc_molecules, 'phi_dist_sigma');
%             mu = get_data_simple(misc_molecules, 'phi_dist_mu');
%             FH12_pos = get_data_simple(misc_molecules, 'FH12_position');
%             mu = mu - FH12_pos;
%             mu = mod(mu,180);
%             scatter(ax,mu,sigma);
%             ax.YLim = [0 10];
%             ax.XLim = [0 180];

        case 'all immobilization times'
%             vals = get_data_simple(misc_molecules,'all_relative_immobilization_times');
            immobilization_reactions = get_data_simple(misc_molecules,'immobilization_reactions');
            immobilization_reactions = get_immobilization_reactions_specific_fuel_and_time(immobilization_reactions(:),1:6,first_t,last_t);
            vals = get_data_simple(immobilization_reactions,'relative_immobilization_time');
            x_label = 'all immobilization times';
            bin_width = 5;
            x_tick = 0:60:1000;
            x_lim = lims_immobilization_times;

            plot_immobilization_profiles(handles,plot_info);
%             plot_immobilization_times_histograms(handles,plot_info);

        case 'F1 immobilization times'
            immobilization_reactions = get_data_simple(misc_molecules,'immobilization_reactions');
            immobilization_reactions = get_immobilization_reactions_specific_fuel_and_time(immobilization_reactions(:),1,first_t,last_t);
            vals = get_data_simple(immobilization_reactions,'relative_immobilization_time');
            x_label = 'F1 immobilization times';
            bin_width = 5;
            x_tick = 0:60:1000;
            x_lim = lims_immobilization_times;
        case 'F2 immobilization times'
            immobilization_reactions = get_data_simple(misc_molecules,'immobilization_reactions');
            immobilization_reactions = get_immobilization_reactions_specific_fuel_and_time(immobilization_reactions(:),2,first_t,last_t);
            vals = get_data_simple(immobilization_reactions,'relative_immobilization_time');
            x_label = 'F2 immobilization times';
            bin_width = 5;
            x_tick = 0:60:1000;
            x_lim = lims_immobilization_times;
        case 'F3 immobilization times'
            immobilization_reactions = get_data_simple(misc_molecules,'immobilization_reactions');
            immobilization_reactions = get_immobilization_reactions_specific_fuel_and_time(immobilization_reactions(:),3,first_t,last_t);
            vals = get_data_simple(immobilization_reactions,'relative_immobilization_time');
            x_label = 'F3 immobilization times';
            bin_width = 5;
            x_tick = 0:60:1000;
            x_lim = lims_immobilization_times;
        case 'F4 immobilization times'
            immobilization_reactions = get_data_simple(misc_molecules,'immobilization_reactions');
            immobilization_reactions = get_immobilization_reactions_specific_fuel_and_time(immobilization_reactions(:),4,first_t,last_t);
            vals = get_data_simple(immobilization_reactions,'relative_immobilization_time');
            x_label = 'F4 immobilization times';
            bin_width = 5;
            x_tick = 0:60:1000;
            x_lim = lims_immobilization_times;
        case 'F5 immobilization times'
            immobilization_reactions = get_data_simple(misc_molecules,'immobilization_reactions');
            immobilization_reactions = get_immobilization_reactions_specific_fuel_and_time(immobilization_reactions(:),5,first_t,last_t);
            vals = get_data_simple(immobilization_reactions,'relative_immobilization_time');
            x_label = 'F5 immobilization times';
            bin_width = 5;
            x_tick = 0:60:1000;
            x_lim = lims_immobilization_times;
        case 'F6 immobilization times'
            immobilization_reactions = get_data_simple(misc_molecules,'immobilization_reactions');
            immobilization_reactions = get_immobilization_reactions_specific_fuel_and_time(immobilization_reactions(:),6,first_t,last_t);
            vals = get_data_simple(immobilization_reactions,'relative_immobilization_time');
            x_label = 'F6 immobilization times';
            bin_width = 5;
            x_tick = 0:60:1000;
            x_lim = lims_immobilization_times;
%             y_lim = [0 10];
        case 'all release times'
            release_reactions = get_data_simple(misc_molecules,'release_reactions');
            release_reactions = get_release_reactions_specific_anti_fuel_and_time(release_reactions(:),1:6,first_t,last_t);
            vals = get_data_simple(release_reactions,'relative_release_time');
            x_label = 'all release times';
            bin_width = 5;
            x_tick = 0:60:1000;
            x_lim = [0 max_lim_release_times];

            plot_release_profiles(handles,plot_info);
%             plot_release_times_histograms(handles,plot_info);

        case 'AF1 release times'
            release_reactions = get_data_simple(misc_molecules,'release_reactions');
            release_reactions = get_release_reactions_specific_anti_fuel_and_time(release_reactions(:),1,first_t,last_t);
            vals = get_data_simple(release_reactions,'relative_release_time');
            x_label = 'AF1 release times';
            bin_width = 5;
            x_tick = 0:60:1000;
            x_lim = [0 max_lim_release_times];
        case 'AF2 release times'
            release_reactions = get_data_simple(misc_molecules,'release_reactions');
            release_reactions = get_release_reactions_specific_anti_fuel_and_time(release_reactions(:),2,first_t,last_t);
            vals = get_data_simple(release_reactions,'relative_release_time');
            x_label = 'AF2 release times';
            bin_width = 5;
            x_tick = 0:60:1000;
            x_lim = [0 max_lim_release_times];
        case 'AF3 release times'
            release_reactions = get_data_simple(misc_molecules,'release_reactions');
            release_reactions = get_release_reactions_specific_anti_fuel_and_time(release_reactions(:),3,first_t,last_t);
            vals = get_data_simple(release_reactions,'relative_release_time');
            x_label = 'AF3 release times';
            bin_width = 5;
            x_tick = 0:60:1000;
            x_lim = [0 max_lim_release_times];
        case 'AF4 release times'
            release_reactions = get_data_simple(misc_molecules,'release_reactions');
            release_reactions = get_release_reactions_specific_anti_fuel_and_time(release_reactions(:),4,first_t,last_t);
            vals = get_data_simple(release_reactions,'relative_release_time');
            x_label = 'AF4 release times';
            bin_width = 5;
            x_tick = 0:60:1000;
            x_lim = [0 max_lim_release_times];
        case 'AF5 release times'
            release_reactions = get_data_simple(misc_molecules,'release_reactions');
            release_reactions = get_release_reactions_specific_anti_fuel_and_time(release_reactions(:),5,first_t,last_t);
            vals = get_data_simple(release_reactions,'relative_release_time');
            x_label = 'AF5 release times';
            bin_width = 5;
            x_tick = 0:60:1000;
            x_lim = [0 max_lim_release_times];
        case 'AF6 release times'
            release_reactions = get_data_simple(misc_molecules,'release_reactions');
            release_reactions = get_release_reactions_specific_anti_fuel_and_time(release_reactions(:),6,first_t,last_t);
            vals = get_data_simple(release_reactions,'relative_release_time');
            x_label = 'AF6 release times';
            bin_width = 5;
            x_tick = 0:60:1000;
            x_lim = [0 max_lim_release_times];
%             y_lim = [0 10];
        case 'all step times'
            step_reactions = get_data_simple(misc_molecules,'step_reactions');
            filtered_step_reactions = filter_step_reactions(step_reactions(:),1:6,first_t,last_t,settings);
            vals = get_data_simple(filtered_step_reactions,'relative_step_t_2');
            x_label = 'Step completion time (s)';
            bin_width = 5;
            x_lim = lims_step_times;
            vals(vals<0) = 0;
%             x_lim = [-0 650];
            x_lim = [-0 60];
            y_lim = [0 400];
%             plot_step_times_histograms(step_reactions,first_t,last_t,settings);
%             plot_step_profiles(handles,plot_info);
            plot_step_profile_all(handles,plot_info);
%             plot_step_profile_for_each_molecule(handles,plot_info);
        case 'all first step times'
            step_reactions = get_data_simple(misc_molecules,'step_reactions');
            filtered_step_reactions = filter_step_reactions(step_reactions(:),1:6,first_t,last_t,settings);
            vals = get_data_simple(filtered_step_reactions,'relative_step_t_1');
            x_label = 'Step times (s)';
            bin_width = 15;
            x_lim = lims_step_times;
            vals(vals<0) = 0;
            x_lim = [-10 800];
        case 'all second step times'
            step_reactions = get_data_simple(misc_molecules,'step_reactions');
            filtered_step_reactions = filter_step_reactions(step_reactions(:),1:6,first_t,last_t,settings);
%             firsts = get_data_simple(filtered_step_reactions,'relative_step_t_1');
            seconds = get_data_simple(filtered_step_reactions,'relative_step_t_2');
%             relative = seconds - firsts;
            vals = seconds;
            x_label = 'Step times (sec)';
            bin_width = 15;
            x_lim = lims_step_times;
            vals(vals<0) = 0;
            x_lim = [-10 800];
        case 'AF1 step times'
            step_reactions = get_data_simple(misc_molecules,'step_reactions');
            filtered_step_reactions = filter_step_reactions(step_reactions(:),1,first_t,last_t,settings);
            vals = get_data_simple(filtered_step_reactions,'relative_step_t_2');
            vals(vals<0) = 0;
            x_label = 'AF1 step times (sec)';
            bin_width = 5;
            x_tick = 0:20:100;
            x_lim = lims_step_times;
        case 'AF2 step times'
            step_reactions = get_data_simple(misc_molecules,'step_reactions');
            filtered_step_reactions = filter_step_reactions(step_reactions(:),2,first_t,last_t,settings);
            vals = get_data_simple(filtered_step_reactions,'relative_step_t_2');
            vals(vals<0) = 0;
            x_label = 'AF2 step times (sec)';
            bin_width = 5;
            x_tick = 0:20:100;
            x_lim = lims_step_times;
        case 'AF3 step times'
            step_reactions = get_data_simple(misc_molecules,'step_reactions');
            filtered_step_reactions = filter_step_reactions(step_reactions(:),3,first_t,last_t,settings);
            vals = get_data_simple(filtered_step_reactions,'relative_step_t_2');
            vals(vals<0) = 0;
            x_label = 'AF3 step times (sec)';
            bin_width = 5;
            x_tick = 0:20:100;
            x_lim = lims_step_times;
        case 'AF4 step times'
            step_reactions = get_data_simple(misc_molecules,'step_reactions');
            filtered_step_reactions = filter_step_reactions(step_reactions(:),4,first_t,last_t,settings);
            vals = get_data_simple(filtered_step_reactions,'relative_step_t_2');
            vals(vals<0) = 0;
            x_label = 'AF4 step times (sec)';
            bin_width = 5;
            x_tick = 0:20:100;
            x_lim = lims_step_times;
        case 'AF5 step times'
            step_reactions = get_data_simple(misc_molecules,'step_reactions');
            filtered_step_reactions = filter_step_reactions(step_reactions(:),5,first_t,last_t,settings);
            vals = get_data_simple(filtered_step_reactions,'relative_step_t_2');
            vals(vals<0) = 0;
%             x_label = 'AF5 step times (sec)';
            x_label = 'F1 step times (sec)';
            bin_width = 5;
            x_tick = 0:20:100;
            x_lim = lims_step_times;
        case 'AF6 step times'
            step_reactions = get_data_simple(misc_molecules,'step_reactions');
            filtered_step_reactions = filter_step_reactions(step_reactions(:),6,first_t,last_t,settings);
            vals = get_data_simple(filtered_step_reactions,'relative_step_t_2');
            vals(vals<0) = 0;
%             x_label = 'AF6 step times (sec)';
            x_label = 'F2 step times (sec)';
            bin_width = 5;
            x_tick = 0:20:100;
            x_lim = lims_step_times;
%             y_lim = [0 10];
        case 'all step sizes'
            step_reactions = get_data_simple(misc_molecules,'step_reactions');
            filtered_step_reactions = filter_step_reactions(step_reactions(:),1:6,first_t,last_t,settings);
%             first_step = get_data_simple(filtered_step_reactions,'step_size_total');
%             second_step = get_data_simple(filtered_step_reactions,'step_size_2');
%             vals = first_step + second_step;
            
            vals = get_data_simple(filtered_step_reactions,'step_size_total');
            x_label = 'all step sizes';
            bin_width = step_size_bin_width;
            x_lim = lims_step_sizes;
%             plot_step_sizes_histograms(misc_molecules,first_t,last_t,settings,step_size_bin_width);
%             show_table_avg_step_sizes(step_reactions,first_t,last_t,settings);
%             plot_avg_step_sizes_per_molecule(misc_molecules,first_t,last_t,settings);
            plot_avg_step_sizes(misc_molecules,first_t,last_t,settings);
%             plot_avg_step_sizes_avg_per_mol(misc_molecules,first_t,last_t,settings);
        case 'all first step sizes'
            step_reactions = get_data_simple(misc_molecules,'step_reactions');
            filtered_step_reactions = filter_step_reactions(step_reactions(:),1:6,first_t,last_t,settings);
            vals = get_data_simple(filtered_step_reactions,'step_size_1');
            x_label = 'all step sizes';
            bin_width = step_size_bin_width;
            x_lim = lims_step_sizes;
        case 'all second step sizes'
            step_reactions = get_data_simple(misc_molecules,'step_reactions');
            filtered_step_reactions = filter_step_reactions(step_reactions(:),1:6,first_t,last_t,settings);
            vals = get_data_simple(filtered_step_reactions,'step_size_2');
            x_label = 'all step sizes';
            bin_width = step_size_bin_width;
            x_lim = lims_step_sizes;

        case 'AF1 step sizes'
            step_reactions = get_data_simple(misc_molecules,'step_reactions');
            filtered_step_reactions = filter_step_reactions(step_reactions(:),1,first_t,last_t,settings);
            vals = get_data_simple(filtered_step_reactions,'step_size_total');
%             vals = abs(vals);
%             vals(vals<0) = [];
            x_label = 'AF1 step sizes';
            bin_width = step_size_bin_width;
%             x_tick = 0:5:1000;
%             x_lim = [0 100];
            x_lim = lims_step_sizes;
        case 'AF2 step sizes'
            step_reactions = get_data_simple(misc_molecules,'step_reactions');
            filtered_step_reactions = filter_step_reactions(step_reactions(:),2,first_t,last_t,settings);
            vals = get_data_simple(filtered_step_reactions,'step_size_total');
%             vals = abs(vals);
            x_label = 'AF2 step sizes';
            bin_width = step_size_bin_width;
%             x_tick = 0:5:1000;
%             x_lim = [0 100];
            x_lim = lims_step_sizes;
        case 'AF3 step sizes'
            step_reactions = get_data_simple(misc_molecules,'step_reactions');
            filtered_step_reactions = filter_step_reactions(step_reactions(:),3,first_t,last_t,settings);
            vals = get_data_simple(filtered_step_reactions,'step_size_total');
%             vals = abs(vals);
            x_label = 'AF3 step sizes';
            bin_width = step_size_bin_width;
%             x_tick = 0:5:1000;
%             x_lim = [0 100];
            x_lim = lims_step_sizes;
        case 'AF4 step sizes'
            step_reactions = get_data_simple(misc_molecules,'step_reactions');
            filtered_step_reactions = filter_step_reactions(step_reactions(:),4,first_t,last_t,settings);
            vals = get_data_simple(filtered_step_reactions,'step_size_total');
%             vals = abs(vals);
            x_label = 'AF4 step sizes';
            bin_width = step_size_bin_width;
%             x_tick = 0:5:1000;
%             x_lim = [0 100];
            x_lim = lims_step_sizes;
        case 'AF5 step sizes'
            step_reactions = get_data_simple(misc_molecules,'step_reactions');
            filtered_step_reactions = filter_step_reactions(step_reactions(:),5,first_t,last_t,settings);
            vals = get_data_simple(filtered_step_reactions,'step_size_total');
%             vals = abs(vals);
            x_label = 'AF5 step sizes';
            bin_width = step_size_bin_width;
%             x_tick = 0:5:1000;
%             x_lim = [0 100];
            x_lim = lims_step_sizes;
        case 'AF6 step sizes'
            step_reactions = get_data_simple(misc_molecules,'step_reactions');
            filtered_step_reactions = filter_step_reactions(step_reactions(:),6,first_t,last_t,settings);
            vals = get_data_simple(filtered_step_reactions,'step_size_total');
%             vals = abs(vals);
            x_label = 'AF6 step sizes';
            bin_width = step_size_bin_width;
%             x_tick = 0:5:1000;
%             x_lim = [0 100];
            x_lim = lims_step_sizes;
        case 'fuel activity - F AF'
            fuel_array = calculate_fuel_activity_F_AF(misc_molecules,first_t,last_t);
            vals = fuel_array;
            x_label = 'fuel activity - F AF';
            bin_width = 0.9;
            x_lim = [0 7];
            x_tick = 1:6;

            if init_plot
                f=figure;
                f.Color = [1 1 1];
                f.Position(2) = f.Position(2) * 0.7;
                ax = axes(f);
                bar(ax,vals);
                ax.XLabel.String = 'fuel #';
                ax.YLabel.String = 'responsiveness';
                ax.FontWeight = 'bold';
                ax.FontSize = 14;
%                 ax.FontSize = 20;
                ax.YLim = [0 1];
                ax.XGrid = 'on';
                ax.YGrid = 'on';
%                 hist3(ax,X, 'CdataMode','auto','ctrs',{-490:20:490,-490:20:490});
                % colorbar
                % % ax.Colormap = gray(100);
                % view(2);
    
                % % ax.XLim = [-200 200];
                % % ax.YLim = [-200 200];
                % ax.XTick = -500:100:500;
            end
        case 'error distribution - hmm'
            fuel_array = calculate_no_response_distribution_hmm(misc_molecules,first_t,last_t,settings);
            vals = fuel_array;
            x_label = 'error distribution - hmm';
            bin_width = 0.9;
            x_lim = [0 7];
            x_tick = 1:6;
            
            if init_plot
                plot_error_distribution(vals);
            end
        case 'error distribution - regular'
            fuel_array = calculate_error_distribution_manual(misc_molecules,first_t,last_t,settings);
            vals = fuel_array;
            x_label = 'error distribution - hmm';
            bin_width = 0.9;
            x_lim = [0 7];
            x_tick = 1:6;       
            plot_error_distribution(vals);
            
        case 'avg steps until error'
            all_avgs = [];
            for i=1:num_misc_mol
                molecule = misc_molecules(i);
                mol_streaks = calculate_streaks(molecule, first_t, last_t, settings);
                avg = mean(mol_streaks);
                all_avgs = [all_avgs; avg]; 
            end
            x_label = 'avg num steps until error';
%                 bin_width = 0.9;
%                 x_lim = [0 7];
            vals = all_avgs;
        case 'max steps until error'
            all_maxima = [];
            for i=1:num_misc_mol
                molecule = misc_molecules(i);
                mol_streaks = calculate_streaks(molecule, first_t, last_t, settings);
                mx = max(mol_streaks);
                all_maxima = [all_maxima; mx]; 
            end
            x_label = 'max num steps until error';
            vals = all_maxima;

            plot_max_steps_profile(all_maxima);

        case 'num steps total'
            all_total_steps = [];
            for i=1:num_misc_mol
                molecule = misc_molecules(i);
                step_reactions = get_data_simple(molecule,'step_reactions');
                filtered_step_reactions = filter_step_reactions(step_reactions(:),1:6,first_t,last_t,settings);
                num = length(filtered_step_reactions);
                all_total_steps = [all_total_steps; num]; 
            end
            vals = all_total_steps;
            bin_width = 5;
            x_label = 'num steps total';
    end

    if init_plot
        cla(handles.ax_hist_linear);
        set(handles.ax_hist_linear,'XTickMode','auto','XlimMode','auto','YTickMode','auto','YlimMode','auto');
%         histogram(handles.ax_hist_linear,vals,'BinWidth',bin_width,'BinLimits',x_lim);
%         clc
%         disp(length(vals(~isinf(vals))));

        switch new_plot_type
            case 'avg int (phi)'
                bar(handles.ax_hist_linear,0:5:355,vals);
            otherwise
                if exist('bin_width','var')
%                     histogram(handles.ax_hist_linear,vals,'BinWidth',bin_width,'Normalization','pdf');
                    histogram(handles.ax_hist_linear,vals,'BinWidth',bin_width);
%                     histogram(handles.ax_hist_linear,vals,'BinWidth',bin_width,'BinLimits',[0 180]);
                else
                    histogram(handles.ax_hist_linear,vals);
                end
                if exist('x_lim','var')
                    handles.ax_hist_linear.XLim = x_lim;
                end
                if exist('y_lim','var')
                    handles.ax_hist_linear.YLim = y_lim;
                end
                if exist('x_tick','var')
                    handles.ax_hist_linear.XTick = x_tick;
                else
% %                     handles.ax_hist_linear.XTick = -900:30:4800;
                end
                handles.ax_hist_linear.FontSize = 20;
%                 handles.ax_hist_linear.FontSize = 14;
                handles.ax_hist_linear.FontWeight = 'bold';
                set(handles.ax_hist_linear,'XGrid','on');
%                 handles.ax_hist_linear.YLabel.String = 'Counts';
                handles.ax_hist_linear.YLabel.String = 'Counts';
                handles.ax_hist_linear.XDir = 'normal';
                handles.ax_hist_linear.XLabel.String = x_label;
                handles.ax_hist_linear.GridAlpha = 0.5;        

%                 handles.ax_hist_linear.YLim = [0 0.2];
%                 handles.ax_hist_linear.YLim = [0 30];        
%                 handles.ax_hist_linear.GridAlpha = 0.5;        
                if plot_gauss_fitting
                    max_val = max(handles.ax_hist_linear.Children.Values);
                    y_gauss = y_gauss * max_val / max(y_gauss);
                    hold(handles.ax_hist_linear,'on');
                    plot(handles.ax_hist_linear,x_gauss,y_gauss)
                end
        end

    else
%         set(handles.ax_hist_linear.Children,'Data',vals,'NumBins',36,'BinWidth',5);
        switch new_plot_type
            case 'avg int (phi)'
            otherwise
                set(handles.ax_hist_linear.Children,'Data',vals);
        end
        
    end
%     t6 = toc;


