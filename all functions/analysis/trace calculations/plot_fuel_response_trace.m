function plot_fuel_response_trace(handles,misc_molecules,first_t,last_t,analysis_mode,plot_mode)

%     fuel_array = zeros(1,6);

    first_t = 0;
    % for allocation - assume divides by 6
    molecule = misc_molecules(1);
    immobilization_reactions = get_immobilization_reactions_specific_fuel_and_time(molecule.immobilization_reactions(:),6,first_t,last_t);
    num_cycles = length(immobilization_reactions);

    num_mol = length(misc_molecules);
    traces = zeros(num_mol,6,num_cycles);

%     F1_rxns = [];
%     F2_rxns = [];
%     F3_rxns = [];
%     F4_rxns = [];
%     F5_rxns = [];
%     F6_rxns = [];

    for mol = 1:length(misc_molecules)
        molecule = misc_molecules(mol);
        for  i=1:6
            switch analysis_mode
                % F AF
                case 1                  
                    immobilization_reactions = get_immobilization_reactions_specific_fuel_and_time(molecule.immobilization_reactions(:),i,first_t,last_t);
                    immobilization_reactions = immobilization_reactions(1:num_cycles);
                    times = get_data_simple(immobilization_reactions,'relative_immobilization_time');
                    times(~isinf(times)) = 1;
                    times(isinf(times)) = 0;
                    traces(mol,i,:) = times;
                case 2
                    step_reactions = molecule.step_reactions;
                    MAX_ABS_STEP_SIZE = 10;
                    counter = 1;
                    for j=1:length(step_reactions)
                        step = step_reactions(j);
                        if ~ismember(step.anti_fuel_num,i)
                            continue;
                        end
                        responsive = abs(step.step_size) > MAX_ABS_STEP_SIZE;        
                        traces(mol,i,counter) = responsive;
                        counter = counter + 1;
                        if counter > num_cycles
                            break;
                        end
                    end
            end
        end
    end
    
    % collapse all molecules
    collapsed_traces = zeros(6,num_cycles);
    for i=1:6
        fuel_i_traces = traces(:,i,:);
        fuel_i_traces = reshape(fuel_i_traces,[num_mol num_cycles]);
%         fuel_i_traces = fuel_i_traces';
        fuel_i__collapse = mean(fuel_i_traces,1);
        collapsed_traces(i,:) = fuel_i__collapse;
    end

    1;

    % now calculate ratio trace
    
    try
        close(handles.figure_temp);
    catch e
    end
    f=figure;
    handles.figure_temp = f;
    f.Position(4) = f.Position(4) * 0.6;
    f.Color = [1 1 1];
    ax = axes(f);

    switch plot_mode
        % even odd
        case 1
            odd = collapsed_traces([1,3,5],:);
            odd = sum(odd,1);
        
            even = collapsed_traces([2,4,6],:);
            even = sum(even,1);

            plot(ax,odd,'-o','LineWidth',2);
            hold(ax,'on');
            plot(ax,even,'--o','LineWidth',2);
            ax.YLim = [0 3];
            ax.FontSize = 14;
            ax.FontWeight = 'bold';
            ax.YTick = 0:3;
            ax.XTick = 1:length(odd);
            ax.XGrid = 'on';
            ax.YGrid = 'on';
            legend(ax,{'odd','even'},'Location','northeastoutside');

        % all 6
        case 2
            for i=1:6
%                 plot(ax,collapsed_traces(i,:),'-o','LineWidth',2);
                trace = collapsed_traces(i,:);
                for j=1:num_cycles
                    trace(j) = trace(j) * j;
                end
                scatter(ax,trace,(7-i)*ones(1,num_cycles),'filled');
                hold(ax,'on');
            end

            ax.YLim = [1 6];
            ax.XLim = [1 num_cycles];
            ax.FontSize = 14;
            ax.YTick = [];
            ax.FontWeight = 'bold';
%             ax.YTick = 0:1;
%             ax.XTick = 1:length(odd);
            legend(ax,{'1','2','3','4','5','6'},'Location','northeastoutside');
%             imagesc(ax,collapsed_traces);
%             ax.Colormap = gray(10);
%             ax.XGrid = 'on';
%             ax.YGrid = 'on';
%             ax.XTick = 0.5:num_cycles;
%             ax.YTick = 0.5:num_mol;



    end















