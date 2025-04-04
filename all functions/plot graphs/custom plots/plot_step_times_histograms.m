function plot_step_times_histograms(step_reactions,first_t,last_t,settings)

 % all 6 with subplots
    f=figure('Color',[1 1 1]);
    f.Position(3) = f.Position(3)  * 1.3;
    f.Position(2) = f.Position(2)  * 0.5;
    f.Position(1) = f.Position(1)  * 1.5;
    for i=1:6
        filtered_step_reactions = filter_step_reactions(step_reactions(:),i,first_t,last_t,settings);
        vals_fig = get_data_simple(filtered_step_reactions,'relative_step_t_2');
        vals_fig(vals_fig<0) = 0;
        ax = subplot(2,3,i);
        bin_width = 20;
%                 x_lim = lims_step_times;
        x_lim = [0 600];
        histogram(ax,vals_fig,'BinWidth',bin_width);
        ax.XLim = x_lim;
        ax.XLabel.String = sprintf('step times AF%d (sec)',i);
        ax.YLabel.String = 'counts';
        ax.YLim = [-5 20];
%         ax.YLim = [0 10];
    end













