function plot_avg_step_sizes_per_molecule(molecules,first_t,last_t,settings)

    num_mol = length(molecules);

    f=figure('Color',[1 1 1]);
    f.Position(2) = f.Position(2)  * 0.5;
    ax = axes(f);

    for i=1:num_mol
        molecule = molecules(i);
        arr = zeros(6,1);
        for j=1:6
            step_reactions = get_data_simple(molecule,'step_reactions');
            filtered_step_reactions = filter_step_reactions(step_reactions(:),j,first_t,last_t,settings);
            vals = get_data_simple(filtered_step_reactions,'step_size');
            avg = mean(vals);
            arr(j) = avg;
        end
        hold(ax,'on');
        plot(ax,arr,'LineWidth',2);
    end
    ax.FontSize = 12;
    ax.FontWeight = 'bold';
    ax.XLabel.String = 'step AF #';
    ax.YLabel.String = 'step size (°)';
    ax.YLim = [0 60];



