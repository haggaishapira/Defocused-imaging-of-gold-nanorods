function plot_max_steps_profile(maxima)


    f=figure;
    f.Position(2) = f.Position(2) * 0.5;
    ax = axes(f);

%     histogram(ax,maxima);

    maxima = sort(maxima,'descend');
    num_mol = length(maxima);
    results = zeros(num_mol,1);

    for i=1:num_mol
       
    end

%     plot(ax,maxima);
    bar(ax,maxima);
    ax.YLim = [0 40];