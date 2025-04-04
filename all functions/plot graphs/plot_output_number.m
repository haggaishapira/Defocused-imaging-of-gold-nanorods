function handles = plot_output_number(handles,plot_info)  
    


    old_plot_type = plot_info.current_plots{5};
    new_plot_type = plot_info.new_plots{5};
    disp_mol = plot_info.disp_mol;
    molecules = plot_info.misc_molecules;

    combine_statistics = plot_info.combine_statistics;
    

    init_plot = ~strcmp(old_plot_type,new_plot_type);


    first_frame = plot_info.first_frame;
    last_frame = plot_info.last_frame;
    first_t = plot_info.first_t;
    last_t = plot_info.last_t;

%     curr_frame = plot_info.curr_frame;
%     curr_t = plot_info.curr_t;
%     t = disp_mol.t;
    analysis = plot_info.analysis;
    settings = handles.extra_calculations_settings;
    
    acquisition = plot_info.acquisition;
    misc_molecules = plot_info.misc_molecules;
    num_misc_mol = plot_info.num_misc_mol;

    if plot_info.num_misc_mol == 0
        return;
    end

%     fig_fitting = figure;
%     fig_fitting.Visible = 'off';
%     ax_fitting = axes(fig_fitting);
%     [first_frame,last_frame,first_t,last_t] = get_timeframe(handles,plot_info.analysis);
    misc_molecule_frames = plot_info.misc_molecule_frames;

    output_number = 1;
    
    
    if output_number
        switch new_plot_type
            case 'diffusion constant'
%                 phis = get_data(misc_molecules,num_misc_mol,'trace_phi_whole_rel_FH12',first_frame,last_frame);
                phis = get_data(misc_molecules,num_misc_mol,'trace_phi_whole',first_frame,last_frame,1);
                % molecules left right

                sqs = phis .^ 2;
                mn = mean(sqs,2);
                root = mn .^ 0.5;
                y = root;
                % y = (2*D*t)^0.5

                F = @(x,xdata) (2*x(1)*xdata).^0.5;
                x0 = 10000;
                t = plot_info.analysis.t(first_frame:last_frame);
                t = t';
                [x,resnorm,~,exitflag,output] = lsqcurvefit(F,x0,t,y);
                diffusion_const = x; % units: degrees^2/sec
                diffusion_const = diffusion_const / 1000; % units: degrees^2/ms

                val = diffusion_const;
            case 'stuck'
                stuck = cell2mat({misc_molecules.stuck});
                num_stuck = length(find(stuck>0));
                fraction_stuck = num_stuck/num_misc_mol;
                val = fraction_stuck;

                % plot also all molecules statiststs all batches
                calc = 0;
                if calc
                    num_batches = length(handles.batches);
                    results = [];
                    for i=1:num_batches
                        results_batch = [];
                        file_nums = get_file_nums_in_batch(handles,i);
                        for j=1:length(file_nums)
                            analysis = handles.analyses(file_nums(j));
                            stuck = cell2mat({analysis.molecules.stuck});
                            results_batch = [results_batch; stuck'];
                        end
                        results = [results results_batch];
                    end
                    num_mol = size(results,1);
    
                    % most correct cycles
                    num_cycles = (num_batches)/2;
                    cycles = zeros(num_mol,num_cycles);
                    for i=1:num_cycles
    %                     correct_switches = xor(results(:,2:end),results(:,1:end-1));
    %                     num_switches = sum(switches,2)
    %                     for j=1:num_mol
    %                     end
                        cycles(:,i) = results(:,i*2-1) & ~results(:,i*2);
                    end
                    num_correct_switches = sum(cycles,2);
                    [vals,inds] = sort(num_correct_switches,'descend');
    %                 disp(inds);
    
                    file_nums = get_file_nums_in_batch(handles,1);
                    analyses_example = handles.analyses(file_nums);
                    num_mol_all_files = cell2mat({analyses_example.num_mol});
    
                    file_nums_per_mol = zeros(num_mol,1);
                    mols_nums_per_mol = zeros(num_mol,1);
    
                    num_areas = length(file_nums);
                    tot_num_switch_in_area = zeros(num_areas,1);

                    for i=1:num_mol
                        file_num = 1;
                        acc_num_mol = 0;
                        ind_mol = inds(i);
                        while ind_mol>acc_num_mol + num_mol_all_files(file_num)
                            acc_num_mol = acc_num_mol + num_mol_all_files(file_num);    
                            file_num = file_num + 1;    
                        end
                        mol_num = ind_mol - acc_num_mol;
                        mols_nums_per_mol(i) = mol_num;
                        file_nums_per_mol(i) = file_num;
                        
                        tot_num_switch_in_area(file_num) = tot_num_switch_in_area(file_num) + vals(i);
%                         if print
                            fprintf('num cycles: %d, file num: %d, mol num: %d\n',vals(i),file_num,mol_num);
%                         end
                    end
%                     figure
%                     histogram(num_correct_switches);
%                     norm_num_switch_in_area = tot_num_switch_in_area ./ num_mol_all_files' / num_cycles;
                    norm_num_switch_in_area = tot_num_switch_in_area / num_cycles;
                    
%                     for i=1:num_areas
%                         fprintf('area %d, num mol: %d, fuel efficiency: %.2f\n',i,num_mol_all_files(i),norm_num_switch_in_area(i));
%                     end
%                     figure
%                     bar(norm_num_switch_in_area);

%                     for i=1:num_area
%                         tot_num_switch_in_area(i) / num_mol_all_files
%                     end
                    1;
                end                

            case 'dwell time'
                dwell_times = get_data_simple(misc_molecules,'dwell_times');
%                 dwell_times(dwell_times<1) = [];
%                 counts = histcounts(dwell_times,'BinWidth',1);
%                 counts = counts/sum(counts);
                if ~isempty(dwell_times)
%                 fit exponent
%                     f=figure;
%                     ax=axes(f);
%                     histfit(dwell_times,100,'exponential');
                    pd = fitdist(dwell_times','Exponential');
                    mu = pd.mu;
%                     x = 0.1:0.1:50;
%                     y = exp(-x.*mu);
%                     y = y/sum(y);
%                     plot(counts);
%                     hold(ax,'on');
%                     plot(ax,x,y);
                    
                    
                    val = mu;
                else
                    val = -1;
                end
%                 plot(ax,counts);
%                 1;
                
            case 'molecule of interest'
                molecule_of_interest = cell2mat({misc_molecules.molecule_of_interest});
                num_molecule_of_interest = length(find(molecule_of_interest>0));
                fraction_molecule_of_interest = num_molecule_of_interest/num_misc_mol;
                val = fraction_molecule_of_interest;
            case 'phi half'
%                 vals = get_data_misc_molecules(misc_molecules,num_misc_mol,'phi_half',misc_molecule_frames,1);
                vals = get_data_misc_molecules(misc_molecules,num_misc_mol,'phi_half',misc_molecule_frames,0);
%                 vals = mod(vals,180);
%                 vals = get_data(misc_molecules,num_misc_mol,'phi_half',first_frame,last_frame);
                val = mean(vals(:));
            case 'd(phi)'
%                 d_phis = cell2mat({curr_molecules.d_phi});
                vals = get_data(misc_molecules,num_misc_mol,'d_phi',first_frame,last_frame);
%                 d_phis_t = d_phis(curr_frame,:);
                val = mean(vals(:));
            case 'd(theta)'
%                 d_thetas = cell2mat({curr_molecules.d_phi});
                vals = get_data(misc_molecules,num_misc_mol,'d_theta',first_frame,last_frame);
%                 vals = vals(curr_frame,:);
                val = mean(vals(:));
            case 'deviation from free rotation'
                vals = get_data_simple(misc_molecules,'deviation_from_free_rotation');
                val = mean(vals);
            case 'd(phi) - exponent fitting'
                val = disp_mol.d_phi_exponent_fitting_mu;
                val = round(val,1);
            case 'defocus'
%                 vals = get_data(molecules,plot_info.num_mol_curr,'defocus',curr_frame,curr_frame);
                vals = get_data_misc_molecules(misc_molecules,num_misc_mol,'defocus',misc_molecule_frames);
%                 defocus = cell2mat({curr_molecules.defocus});
                val = mean(vals(:));
%                 val = vals(curr_frame);
%                 val = mean(vals); 
            case 'avg min dist to another mol'
                val = mean(analysis.distances);
                val = val*0.166;
            case 'immobilization time'
                vals = get_data_simple(misc_molecules,'all_immobilization_times');
                vals(isinf(vals)) = [];
                val = mean(vals);
            case 'release time'
%                 val = disp_mol.release_time;
%                 phi = disp_mol.trace_phi_whole;
%                 phi = disp_mol.phi_half;
%                 val = phi(curr_frame);
                val = plot_info.num_mol_all;
            case 'dissociation time'
                val = disp_mol.dissociation_time;
            case 'phi dist sigma'
                vals = cell2mat({misc_molecules.phi_dist_sigma});
                val = mean(vals);
            case 'phi dist mu'
                vals = cell2mat({misc_molecules.phi_dist_mu});
                vals = vals - cell2mat({misc_molecules.FH12_position});
%                 vals = mod(vals,180);
                val = mean(vals);
            case 'FH12 position'
                vals = cell2mat({misc_molecules.FH12_position});
                val = mean(vals);
            case 'all step response times'
                step_times = [disp_mol.step_times_AF1; disp_mol.step_times_AF2; disp_mol.step_times_AF3; ...
                    disp_mol.step_times_AF4; disp_mol.step_times_AF5; disp_mol.step_times_AF6];       
                val = mean(step_times);
            case 'AF1 step times'
                step_times = disp_mol.step_times_AF1;
                val = mean(step_times);
            case 'AF2 step times'
                step_times = disp_mol.step_times_AF2;
                val = mean(step_times);
            case 'AF3 step times'
                step_times = disp_mol.step_times_AF3;
                val = mean(step_times);
            case 'AF4 step times'
                step_times = disp_mol.step_times_AF4;
                val = mean(step_times);
            case 'AF5 step times'
                step_times = disp_mol.step_times_AF5;
                val = mean(step_times);
            case 'AF6 step times'
                step_times = disp_mol.step_times_AF6;
                val = mean(step_times);
       
            case 'all step sizes'
                step_reactions = get_data_simple(misc_molecules,'step_reactions');
                filtered_step_reactions = filter_step_reactions(step_reactions(:),1:6,first_t,last_t,settings);
                vals = get_data_simple(filtered_step_reactions,'step_size');         
                val = mean(vals);
            case 'AF1 step sizes'
                step_reactions = get_data_simple(misc_molecules,'step_reactions');
                filtered_step_reactions = filter_step_reactions(step_reactions(:),1,first_t,last_t,settings);
                vals = get_data_simple(filtered_step_reactions,'step_size');         
                val = mean(vals);
            case 'AF2 step sizes'
                step_reactions = get_data_simple(misc_molecules,'step_reactions');
                filtered_step_reactions = filter_step_reactions(step_reactions(:),2,first_t,last_t,settings);
                vals = get_data_simple(filtered_step_reactions,'step_size');         
                val = mean(vals);
            case 'AF3 step sizes'
                step_reactions = get_data_simple(misc_molecules,'step_reactions');
                filtered_step_reactions = filter_step_reactions(step_reactions(:),3,first_t,last_t,settings);
                vals = get_data_simple(filtered_step_reactions,'step_size');         
                val = mean(vals);
            case 'AF4 step sizes'
                step_reactions = get_data_simple(misc_molecules,'step_reactions');
                filtered_step_reactions = filter_step_reactions(step_reactions(:),4,first_t,last_t,settings);
                vals = get_data_simple(filtered_step_reactions,'step_size');         
                val = mean(vals);
            case 'AF5 step sizes'
                step_reactions = get_data_simple(misc_molecules,'step_reactions');
                filtered_step_reactions = filter_step_reactions(step_reactions(:),5,first_t,last_t,settings);
                vals = get_data_simple(filtered_step_reactions,'step_size');         
                val = mean(vals);
            case 'AF6 step sizes'
                step_reactions = get_data_simple(misc_molecules,'step_reactions');
                filtered_step_reactions = filter_step_reactions(step_reactions(:),6,first_t,last_t,settings);
                vals = get_data_simple(filtered_step_reactions,'step_size');         
                val = mean(vals);
            case 'max steps until dissociation'
                all_streaks = [];
                for i=1:num_misc_mol
                    molecule = misc_molecules(i);
                    mol_streaks = calculate_streaks(molecule, first_t, last_t, settings);
                    all_streaks = [all_streaks; mol_streaks]; 
                end
%                 val = mean(all_streaks);
                val = max(all_streaks);
                disp(all_streaks);
            case 'max num steps total'
                step_reactions = get_data_simple(misc_molecules,'step_reactions');
%                 filtered_step_reactions = filter_step_reactions(step_reactions(:),1:6,0,inf,settings);
                filtered_step_reactions = filter_step_reactions(step_reactions(:),1:6,first_t,last_t,settings);
                val = length(filtered_step_reactions);
            case 'dissociation per step'
                step_reactions = get_data_simple(misc_molecules,'step_reactions');
                [filtered_step_reactions,num_dissociations] = filter_step_reactions(step_reactions(:),1:6,first_t,last_t,settings);
%                 filtered_step_reactions = [];
%                 settings = handles.extra_calculations_settings;
%                 min_step_size = settings.min_step_size;
%                 max_step_size = settings.max_step_size;

%                 for i=1:length(step_reactions)
%                     step = step_reactions(i);
%                     ok = 1;
%                     ok = ok & step_timeframe_filter(step, first_t, last_t);
%                     if ok
%                         filtered_step_reactions = [filtered_step_reactions; step];
%                     end
%                 end
%                 total_num_steps = length(filtered_step_reactions);
%                 num_dissociations = 0;
%                 for i=1:length(filtered_step_reactions)
%                     step = filtered_step_reactions(i);
% %                     ok = ok & step_size_filter(settings, step);
% 
%                     if step.is_error
%                         num_dissociations = num_dissociations + 1;
%                     end
%                 end
% %                 num_dissociations = length(filtered_step_reactions);
%                 dissociation_per_step = num_dissociations/total_num_steps * 100;
% %                 val = dissociation_per_step;
%                 val = num_dissociations;
% %                 val = total_num_steps/num_dissociations;

            val = num_dissociations;
            

        end
        
        handles.output_number.String = sprintf('%.2f',val);
    end

%     close(fig_fitting);
%     toc
