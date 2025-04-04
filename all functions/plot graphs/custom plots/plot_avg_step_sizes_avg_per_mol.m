function plot_avg_step_sizes_avg_per_mol(molecules,first_t,last_t,settings)

    num_mol = length(molecules);

    f=figure('Color',[1 1 1]);
    f.Position(2) = f.Position(2)  * 0.5;
    ax = axes(f);

    all_data = zeros(num_mol,6);

    for i=1:num_mol
        molecule = molecules(i);
        for j=1:6
            step_reactions = get_data_simple(molecule,'step_reactions');
            filtered_step_reactions = filter_step_reactions(step_reactions(:),j,first_t,last_t,settings);
            vals_1 = get_data_simple(filtered_step_reactions,'step_size_1');
            vals_2 = get_data_simple(filtered_step_reactions,'step_size_2');
            vals = vals_1 + vals_2;
            avg = mean(vals);
            all_data(i,j) = avg;
        end
    end

    stdevs = zeros(6,1);
    avgs = zeros(6,1);
    for i=1:6
        stdevs(i) = std(all_data(:,i));
        avgs(i) = mean(all_data(:,i));
    end

    disp(avgs);

    scatter(ax,1:6,avgs,50,'filled');
    hold(ax,'on');
    err=errorbar(ax,avgs,stdevs,'LineWidth',1,'LineStyle','none');
%     err.Color = [0 0 1];
    ax.FontSize = 12;
    ax.FontWeight = 'bold';
    ax.XLabel.String = 'step AF #';
    ax.YLabel.String = 'step size (°)';
    ax.YLim = [0 70];
    ax.XLim = [0.5 6.5];



