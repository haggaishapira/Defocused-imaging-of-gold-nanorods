function plot_avg_step_sizes(molecules,first_t,last_t,settings)

    num_mol = length(molecules);

    f=figure('Color',[1 1 1]);
    f.Position(2) = f.Position(2)  * 0.5;
    ax = axes(f);

    all_data = cell(6,1);

    for j=1:6
        step_reactions = get_data_simple(molecules,'step_reactions');
        filtered_step_reactions = filter_step_reactions(step_reactions(:),j,first_t,last_t,settings);
        vals = get_data_simple(filtered_step_reactions,'step_size_1');
        vals = vals + get_data_simple(filtered_step_reactions,'step_size_2');
        all_data{j} = vals;
    end

    stdevs = zeros(6,1);
    avgs = zeros(6,1);
    for i=1:6
        stdevs(i) = std(all_data{i});
        avgs(i) = mean(all_data{i});       
%         disp(length(all_data{i}));
    end
    disp(avgs);

    % cryo prediction
    predicted_sizes = [30.7 34.8 30.7 27.6 28.6 27.6];
    hold(ax,'on');
    sc = scatter(ax,1:6,predicted_sizes,70,'square','filled');
    sc.MarkerFaceColor = [1 0 0];
    sc.MarkerEdgeColor = [1 0 0];

    % experiment
    sc=scatter(ax,1:6,avgs,50,'filled');
    col = [0, 0.4470, 0.7410];
    sc.MarkerFaceColor = col;
    sc.MarkerEdgeColor = col;
    hold(ax,'on');

    err=errorbar(ax,avgs,stdevs,'LineWidth',1,'LineStyle','none');
%     err.Color = [0 0 1];
    ax.FontSize = 20;
    ax.FontWeight = 'bold';
%     ax.XLabel.String = 'step';
    ax.YLabel.String = 'step size (°)';
    ax.YLim = [0 60];
    ax.XLim = [0.5 6.5];
    ax.YTick = 0:10:60;

%     xtlbls = {'1→3' '2→4' '3→5' '4→6' '5→1' '6→2'};
    xtlbls = {'1\rightarrow3' '2\rightarrow4' '3\rightarrow5' '4\rightarrow6' '5\rightarrow1' '6\rightarrow2'};
    xticks(1:6) % define tick locations explicitly
    xticklabels(xtlbls) % define tick labels

    
%     legend_array = {'experiment','cryo-EM'};
    legend_array = {'cryo-EM','experiment'};

    l=legend(legend_array);
    l.Location = 'northeast';
    % l.Location = 'southeast';

    % figure 6
    f.Position = [313   234   894   623];
    ax.Position = [0.2 0.22 0.65 0.55];
    















    
