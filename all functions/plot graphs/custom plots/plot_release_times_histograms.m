function plot_release_times_histograms(handles,plot_info)

    molecules = plot_info.misc_molecules;
    sequence_info = plot_info.sequence_info;
    num_mol = plot_info.num_misc_mol;
    first_frame = plot_info.first_frame;
    last_frame = plot_info.last_frame;
    framerate = plot_info.framerate;
    t = plot_info.analysis.t;
    

    time_intervals = sequence_info.time_intervals;



 % all 6 with subplots
    f=figure('Color',[1 1 1]);
    f.Position(3) = f.Position(3)  * 1.3;
    f.Position(2) = f.Position(2)  * 0.5;
    f.Position(1) = f.Position(1)  * 1.5;
    for i=1:6
%         filtered_step_reactions = filter_step_reactions(step_reactions(:),i,first_t,last_t,settings);
%         vals_fig = get_data_simple(filtered_step_reactions,'relative_step_t_2');
%         vals_fig(vals_fig<0) = 0;

%         anti_fuel_intervals = time_intervals(2:5,1);
%         total_t_anti_fuel_inc = max(anti_fuel_intervals) - min(anti_fuel_intervals);
%         t_trace = 0:(1/framerate):total_t_anti_fuel_inc;
%         num_frames = length(t_trace);
%         fraction_immobile = zeros(num_frames,1);
        
        release_reactions = get_data_simple(molecules,'release_reactions');
        release_reactions = get_release_reactions_specific_anti_fuel_and_time(release_reactions(:),i,0,inf);
        rel_times = get_data_simple(release_reactions,'relative_release_time');
%         rel_times = sort(rel_times);

        ax = subplot(2,3,i);
        bin_width = 20;
%                 x_lim = lims_step_times;
        x_lim = [0 300];
        histogram(ax,rel_times,'BinWidth',bin_width);
        ax.XLim = x_lim;
        ax.Title.String = sprintf('AF%d',i);
        ax.XLabel.String = sprintf('Time of release (s)',i);
        ax.YLabel.String = 'counts';
        ax.YLim = [0 50];
%         ax.YLim = [0 10];
    end













