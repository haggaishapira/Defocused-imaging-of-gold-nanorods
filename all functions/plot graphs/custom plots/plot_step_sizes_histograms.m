function plot_step_sizes_histograms(step_reactions,first_t,last_t,settings,step_size_bin_width)

% all 6 with subplots
    f=figure('Color',[1 1 1]);
    f.Position(3) = f.Position(3)  * 1.3;
    f.Position(2) = f.Position(2)  * 0.5;
 
    for i=1:6
        filtered_step_reactions = filter_step_reactions(step_reactions(:),i,first_t,last_t,settings);
        vals_fig = get_data_simple(filtered_step_reactions,'step_size');
%                     vals_fig(vals_fig<0) = 0;
        ax = subplot(2,3,i);
        bin_width = step_size_bin_width;
%                 x_lim = lims_step_times;
        x_lim = [0 80];
        histogram(ax,vals_fig,'BinWidth',bin_width);
        ax.XLim = x_lim;
        ax.XLabel.String = sprintf('step sizes AF%d (sec)',i);
        ax.YLabel.String = 'counts';
        ax.YLim = [0 50];
%         ax.YLim = [0 20];
    end








    