function plot_immobilization_times_histograms(handles,plot_info)


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

%         fuel_intervals = time_intervals(2:5,1);
%         total_t_fuel_inc = max(fuel_intervals) - min(fuel_intervals);
%         t_trace = 0:(1/framerate):total_t_fuel_inc;
%         num_frames = length(t_trace);
%         fraction_immobile = zeros(num_frames,1);
        
        immobilization_reactions = get_data_simple(molecules,'immobilization_reactions');
        immobilization_reactions = get_immobilization_reactions_specific_fuel_and_time(immobilization_reactions(:),i,0,inf);
        imm_times = get_data_simple(immobilization_reactions,'relative_immobilization_time');
%         imm_times = sort(imm_times);

        ax = subplot(2,3,i);
        bin_width = 20;
%                 x_lim = lims_step_times;
        x_lim = [0 300];
        histogram(ax,imm_times,'BinWidth',bin_width);
        ax.XLim = x_lim;
        ax.Title.String = sprintf('F%d',i);
        ax.XLabel.String = sprintf('Time of immobilization (s)',i);
        ax.YLabel.String = 'counts';
        ax.YLim = [0 50];
%         ax.YLim = [0 10];
    end













