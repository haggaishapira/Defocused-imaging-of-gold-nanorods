function plot_timings(ax)

    y_lim = ax.YLim;
    plot_info.sm_sequence_rectangles = [];
    for i=1:sequence_info.total_num_steps
        interval = sequence_info.time_intervals(i,:);
        w = interval(2)-interval(1);
        h = y_lim(2)-y_lim(1);
        col = plot_info.command_colors(i,:);
        rec = rectangle(ax,'Position',[interval(1) y_lim(1) w h], 'FaceColor', [col 0.2]);
        plot_info.sm_sequence_rectangles = [plot_info.sm_sequence_rectangles; rec];
        hold(ax,'on');
    end
     