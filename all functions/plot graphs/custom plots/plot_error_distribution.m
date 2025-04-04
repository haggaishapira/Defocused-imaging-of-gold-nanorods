function plot_error_distribution(vals)

    f=figure;
    f.Color = [1 1 1];
    f.Position(4) = f.Position(4) * 0.7;
    f.Position(2) = f.Position(2) * 0.7;
    ax = axes(f);
    bar(ax,vals);
%                 ax.YLim = [0 1];
%     ax.YLim = [0 30];
%     ax.YTick = 0:0.2:1;
    ax.YGrid = 'on';
    ax.XLabel.String = 'fuel #';
%                 ax.YLabel.String = 'responsiveness';
%     ax.YLabel.String = 'error fraction';
    ax.YLabel.String = 'number of errors';
    ax.FontWeight = 'bold';
    ax.FontSize = 14;