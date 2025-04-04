function analysis = perform_extra_calculations(handles,analysis,file_num,file_selection_num,new_file)

%     updated_molecule_structure = [];
    settings = handles.extra_calculations_settings;

%     molecules = analysis.molecules
    vid_len = analysis.vid_len;
    num_mol = analysis.num_mol;    
    framerate = analysis.framerate;
    t = analysis.t;
    molecules = analysis.molecules;
    
    if num_mol == 0
        return;
    end
    
%     [sequence_info,file_num] = get_current_sequence_info(handles);
    sequence_info = handles.sequence_infos(file_num);
    sequence_info = process_sequence_info_2(sequence_info);

    registered_FH12_positions = handles.registered_FH12_positions;

%     [first_frame,last_frame] = get_timeframe(handles,analysis);
    [first_frame,last_frame,first_t,last_t] = get_timeframe(handles,analysis);

    use_registered_FH12_pos = settings.use_registered_angles;

    %%%%%%%%%% EXTRA CALCULATIONS %%%%%%%%%%%%%
    % figure for histogram fitting because it was easy, of course it
    % should be possible to fit without the figure
    fig_fitting = figure;
    fig_fitting.Visible = 'off';
    ax_fitting = axes(fig_fitting);

    molecule_selection = handles.molecule_selections{file_num};
%     molecule_selection = get_current_molecule_selection(handles);
    num_mol_selected = length(molecule_selection);
%     handles.molecule_selections{file_num};

    current_FH_angle = settings.current_FH_angle;

    % apply registered position
    if use_registered_FH12_pos && ~new_file
        
%         nums = handles.registered_FH12_positions_nums;
        
        for mol = 1:num_mol
%             num = molecules(mol).num;
%             ind = find(nums == num);
%             if ~isempty(ind)
%                 molecules(mol).FH12_position = registered_FH12_positions(mol);
                molecules(mol).FH12_position = registered_FH12_positions{file_selection_num}(mol);
%             else
%                 molecules(mol).FH12_position = 0;
%             end

        end
    end

    % single molecule calculations
    %wait here
    wait_bar = waitbar(0,sprintf('performing extra calculations. molecule %d/%d', 0,num_mol));
    for mol = 1:num_mol  
%         disp(mol);

        tic

        molecule = molecules(mol);

        % signal to noise
        int = double(molecule.int(1));
        back = double(molecule.back(1));
        molecule.S2N = int/back;

        %% d_phi and d_theta
%         theta = molecule.trace_theta_whole;
%         molecule.d_theta = [0; abs(theta(2:end) - theta(1:end-1))];    

        phi_all = molecule.trace_phi_whole;
        d_phi_all = [0; abs(phi_all(2:end) - phi_all(1:end-1))];    
        molecule.d_phi = d_phi_all;
%         molecule.d_phi(1:100) = 0;
        
        phi_current_segment = phi_all(first_frame:last_frame);
        d_phi_current_segment = d_phi_all(first_frame:last_frame);


        % intensity as function of angle
%         int_by_angle = zeros(72,1);
        
%         molecule = calc_int_as_func_of_phi(molecule, vid_len);


%         %% release frame
%         [molecule.release_time,molecule.release_frame] = calculate_release_time(d_phi_all,framerate,first_frame,last_frame);
% 
%          %% immobilization frame
       if settings.immobilization_reaction
           [immobilization_time,immobilization_frame] = calculate_immobilization_time(settings,d_phi_all,framerate,first_frame,last_frame);
            % segment after immobilization
            if ~isinf(immobilization_frame)
                phi_immobilized = phi_all(immobilization_frame:end);
                [mu,~] = calculate_phi_gaussian_fit(phi_immobilized);
            else
                 mu = 0;
            end
            if ~use_registered_FH12_pos
                molecule.FH12_position = double(mu - current_FH_angle);
            end
       end
        
        %% free
%         molecule.free = calculate_free(d_phi_all);

        %% dissociation time
        int_segment = molecule.int(first_frame:last_frame);
        [molecule.dissociation_time,molecule.dissociation_frame] = calculate_dissociation_time(int_segment,framerate,first_frame);
        molecule.dissociation_frame = molecule.dissociation_frame + first_frame;
        molecule.dissociation_time = molecule.dissociation_time + first_frame/framerate;

        %% dwell times
        t_current_segment = t(first_frame:last_frame);
%         phi_current_segment = phi_current_segment - molecule.trace_phi_whole(1);
        molecule.dwells = calculate_dwells(settings,t_current_segment,phi_current_segment - molecule.trace_phi_whole(1));

        %% deviation from free rotation
        molecule.deviation_from_free_rotation = calculate_deviation_from_free_rotation(phi_current_segment);


        %% fit exponent to d(phi) distribution
        molecule.d_phi_exponent_fitting_mu = calculate_d_phi_exponent(d_phi_current_segment,ax_fitting);
        
        %% fit RMSD curve to model
        

        %% fit gaussian to phi (stuck molecule)
%         phi_current_segment_180 = mod(phi_current_segment,180);
        [mu,sigma] = calculate_phi_gaussian_fit(phi_current_segment);
        mu = double(mu);
%         sigma = double(sigma);
        molecule.phi_dist_mu = mu;
        molecule.phi_dist_sigma = sigma;

        %% check stuck
        molecule.stuck = molecule.phi_dist_sigma < 10;

        %% stuck correctly
        threshold_error_angle = 15;
        rel_mu = mod(mu - molecule.FH12_position,180);
        angle_error = rel_mu - current_FH_angle;
        molecule.stuck_correctly = molecule.stuck && abs(angle_error) < threshold_error_angle;


        % iterate over frames, 20 sec each segment
        molecule.stuck_trace = zeros(vid_len,1);
        t_interval = 20;
        frame_interval = round(t_interval*framerate);
        for i=1:frame_interval:vid_len
            frames_seg = i:min(i+frame_interval-1,vid_len);
%             disp(frames_seg);
            phi_seg = phi_all(frames_seg);  
            [mu_seg,sigma_seg] = calculate_phi_gaussian_fit(phi_seg);
            stuck = sigma_seg<10;
            molecule.stuck_trace(frames_seg) = stuck;
        end

        if ~use_registered_FH12_pos && settings.fuel_state
            if molecule.stuck
                mu = mu - current_FH_angle;
            end
%             mu = double(mu);
%             mu = mod(mu,180);
            molecule.FH12_position = mu;
        end



        %% iterate segments
%         molecule.all_immobilization_times = [];
%         molecule.all_relative_immobilization_times = [];
%         molecule.all_release_times = [];
%         molecule.all_relative_release_times = [];

        currently_on = 0;
        turn_on_frame = 1;
        molecule.on_frames = [];
%         molecule.off_frames = [];
        molecule.on_segments_gaussian_fittings = [];

        molecule.step_reactions = [];
        molecule.immobilization_reactions = [];
        molecule.release_reactions = [];

        iterate_segments = 1;
        if iterate_segments
            for i=1:sequence_info.total_num_steps
    %             continue;
                interval = sequence_info.time_intervals(i,:);
                frame_start = max(round(interval(1)*framerate),1);
                frame_end_temp = round(interval(2)*framerate);
                if frame_start>vid_len || frame_end_temp>last_frame || frame_start < first_frame
                    continue;
                end

                % if next command is wash, include it also
                % next_command = sequence_info.command_names_full_sequence{i+1};
                % next_next_command = sequence_info.command_names_full_sequence{i+2};
                % if i+1<=sequence_info.total_num_steps && ...
                %         (strcmp(sequence_info.command_names_full_sequence{i+1},'102') || ...
                %         isempty(sequence_info.command_names_full_sequence{i+1}))
                %     % if the command after that is biotin, include it as well
                %     if i+2<=sequence_info.total_num_steps && strcmp(sequence_info.command_names_full_sequence{i+2},'biotin')
                %         final_interval_index = i+2;
                %     else
                %         final_interval_index = i+1;
                %     end
                % else
                %     final_interval_index = i;
                % end

                fuel_group = get_fuel_group();
                anti_fuel_group = get_anti_fuel_group();
                command_name = sequence_info.command_names_full_sequence{i};

%                 if mol == 3
%                     1;
%                 end

                switch command_name
                    case fuel_group 
%                         if i == 1
%                             continue
%                         end
                        if i == sequence_info.total_num_steps || i>1 && ismember(sequence_info.command_names_full_sequence{i-1},fuel_group)
                            continue
                        end    
%                         disp(i);
                        final_interval_index = min(i+4,sequence_info.total_num_steps);
%                         if i>4
%                             continue;
%                         end
%                         final_interval_index = sequence_info.total_num_steps;
                        final_interval = sequence_info.time_intervals(final_interval_index,:);
                        frame_end = round(final_interval(2)*framerate);
                        frame_end = min(frame_end,vid_len); % just in case...

                        [immobilization_time,immobilization_frame] = calculate_immobilization_time(settings,d_phi_all,framerate,frame_start,frame_end);
                        reaction_start_time = sequence_info.time_intervals(i+1,1);

                        if immobilization_frame<inf
                            final_phi = mean(phi_all(immobilization_frame:frame_end));
                        else
                            final_phi = inf;
                        end

                        switch command_name
                            case 'F1'
                                fuel_number = 1;
                            case 'F2'
                                fuel_number = 2;
                            case 'F3'
                                fuel_number = 3;
                            case 'F4'
                                fuel_number = 4;
                            case 'F5'
                                fuel_number = 5;
                            case 'F6'
                                fuel_number = 6;
                            case 'F2 10 uM'
                                fuel_number = 2;
                            otherwise
                                fuel_number = 2;
                        end
                        immobilization_reaction = make_immobilization_reaction(reaction_start_time,immobilization_time,fuel_number,final_phi);
                        molecule.immobilization_reactions = [molecule.immobilization_reactions immobilization_reaction];

                    case anti_fuel_group
                        switch settings.sequence_analysis_method 
                            case 1
                                % F AF
                                if i == sequence_info.total_num_steps || i>1 && ismember(sequence_info.command_names_full_sequence{i-1},anti_fuel_group)
                                    continue
                                end                
                                final_interval_index = min(i+3,sequence_info.total_num_steps);
                            case 2
                                % walking     
                                if i == sequence_info.total_num_steps || i>1 && ismember(sequence_info.command_names_full_sequence{i+1},anti_fuel_group)
                                    continue
                                end                
                                final_interval_index = min(i+3,sequence_info.total_num_steps);
                        end

                        final_interval = sequence_info.time_intervals(final_interval_index,:);
                        frame_end = round(final_interval(2)*framerate);
                        frame_end = min(frame_end,vid_len); % just in case...
                        [release_time,release_frame] = calculate_release_time(settings,d_phi_all,framerate,frame_start,frame_end);
                        reaction_start_time = interval(1) + 30;
                        if release_frame<inf
                            initial_phi = mean(phi_all(frame_start:release_frame));
                        else
                            initial_phi = inf;
                        end
                        switch command_name
                            case 'AF1'
                                anti_fuel_number = 1;
                            case 'AF2'
                                anti_fuel_number = 2;
                            case 'AF3'
                                anti_fuel_number = 3;
                            case 'AF4'
                                anti_fuel_number = 4;
                            case 'AF5'
                                anti_fuel_number = 5;
                            case 'AF6'
                                anti_fuel_number = 6;
                            otherwise
                                anti_fuel_number = 1;
                        end
                        release_reaction = make_release_reaction(reaction_start_time,release_time,anti_fuel_number,initial_phi);
                        molecule.release_reactions = [molecule.release_reactions release_reaction];

                        % perform hmm
                        if settings.analyze_steps_individually
                            % disp(length(molecule.hmm_t_traces));
                            % disp(length(molecule.all_step_sizes));

                            correct_segment = interval(2) - interval(1) == 60;
%                             correct_segment = interval(2) - interval(1) == 30;
%                             correct_segment = 1;
                            if correct_segment
                                % perform hmm
%                                 curr_trace_num = size(molecule.hmm_t_traces,2) + 1;
                                % start from incubation step of previous fuel
                                frame_start = round(sequence_info.time_intervals(i-4,1)*framerate);
%                                 frame_start = round(sequence_info.time_intervals(i-2,1)*framerate);

                                seg_end = min(i+5,sequence_info.total_num_steps);                                
                                frame_end = round(sequence_info.time_intervals(seg_end,2)*framerate);
                                frame_end = min(frame_end,vid_len);
                                phi_for_analysis = double(molecule.trace_phi_whole(frame_start:frame_end));
%                                 phi_for_hmm = phi_for_hmm - double(molecule.trace_phi_whole(1));

                                %%% calculate here the error  - e.g. dissociation possibility - manually
                                frame_start_AF = round(sequence_info.time_intervals(i,1)*framerate);
                                frame_start_AF = frame_start_AF - frame_start + 1;
                                stepping_error = check_error(phi_for_analysis,frame_start_AF);
%                                 if stepping_error
%                                     disp('error');
%                                     fprintf('molecule %d\n',mol);
%                                 end
                                %%%
                                    % regular
%                                     [step_reaction,num_changes] = analyze_step_hmm(settings,phi_for_analysis,t,...
%                                         frame_start,frame_end,stepping_error,command_name,i,sequence_info);
%                                     1;
                                    % iterative
%                                     factor = 2;
%                                     good = 0;
%                                     temp_settings = settings;
%                                     while ~good
%                                         [step_reaction,num_changes] = analyze_step_hmm(temp_settings,phi_for_analysis,t,...
%                                                         frame_start,frame_end,stepping_error,command_name,i,sequence_info);
%                                         if num_changes == 1
%                                             good = 1;
%                                         else
%                                             temp_settings.hmm_crop_interval = round(temp_settings.hmm_crop_interval * factor);
%                                             temp_settings.hmm_smooth_window =  round(temp_settings.hmm_smooth_window * factor);
%                                         end
%                                         disp(temp_settings.hmm_smooth_window);
%                                     end

                                    % new fitting - step function
                                    t_step_trace = (t(frame_start:frame_end))';
%                                     disp(mol);
                                    step_reaction = my_fit_step(settings,phi_for_analysis,t_step_trace,frame_start,...
                                                    frame_end,stepping_error,command_name,i,sequence_info);

%                                   %%% end dont delete %%%
                                    molecule.step_reactions = [molecule.step_reactions; step_reaction];
%                                 end

                            end
                                
                        end
                end        
            end        
        end

        % if molecule is still on, register the frames according to fuel
        % number if not washed still
%         is_fuel = ismember(command_name,fuel_group);
%         if currently_on && is_fuel
%         if currently_on
%             molecule.on_frames = [molecule.on_frames turn_on_frame:last_frame];
%             % fit on_frames
%             phi_for_fit = phi_all(turn_on_frame:last_frame);
%             [mu,sigma] = calculate_phi_gaussian_fit(phi_for_fit);
% %             [mu,sigma] = fit_state_with_180_jumps(phi_for_fit);
% %             mu = mod(mu,360);
%             molecule.on_segments_gaussian_fittings = [molecule.on_segments_gaussian_fittings [mu; sigma]];
%             if ~use_registered_FH12_pos && size(molecule.on_segments_gaussian_fittings,2) == 1
%                 fuel_num = get_fuel_number(command_name);
%                 if isempty(fuel_num)
%                     molecule.FH12_position = 0;
%                 else
%                     FH_angle = get_FH_angle(fuel_num);
%                     molecule.FH12_position = double(mu - FH_angle); 
%                 end
%             end
%         end
        
%         disp(mol);
%         disp(molecule.on_segments_gaussian_fittings);


        % iterate immobilization and release reactions and equalize
        mn = min(length(molecule.immobilization_reactions), length(molecule.release_reactions));
        for i=1:mn
            immob_rxn = molecule.immobilization_reactions(i);
            rel_rxn = molecule.release_reactions(i);
            if isinf(immob_rxn.immobilization_time) || isinf(rel_rxn.release_time)
%             if 1
                molecule.immobilization_reactions(i).immobilization_time = inf;
                molecule.immobilization_reactions(i).relative_immobilization_time = inf;
                molecule.release_reactions(i).release_time = inf;
                molecule.release_reactions(i).relative_release_time = inf;
            end
        end


        molecule.on_trace = zeros(vid_len,1,'logical');
        molecule.on_trace(molecule.on_frames) = true;

        if isempty(molecule.FH12_position) || settings.disable_FH12_positions
            molecule.FH12_position = 0;
        end
        molecule.trace_phi_whole_rel_FH12 = phi_all - molecule.FH12_position;
        molecule.trace_phi_whole_around_0 = phi_all - molecule.phi_dist_mu;


        % hmm trace
        if settings.calc_hmm

            phi_for_analysis = double(molecule.trace_phi_whole(first_frame:last_frame));
            num_states = settings.hmm_num_states;
%             num_traces_curr = size(molecule.hmm_t_traces,2);
            molecule.hmm_t_traces{1} = t(first_frame:last_frame);
            
            transform_smooth = settings.hmm_smooth_trace;
            if transform_smooth
                % smooth
                smooth_window = settings.hmm_smooth_window;
                phi_for_analysis = smooth(phi_for_analysis,smooth_window);
            end
            transform_crop = settings.hmm_crop_trace;
            if transform_crop
                interval = settings.hmm_crop_interval;
                molecule.hmm_t_traces{1} = molecule.hmm_t_traces{1}(1:interval:end);
                phi_for_analysis = phi_for_analysis(1:interval:end);
            end
%             min_phi_hmm = phi_for_hmm(1);
%             phi_for_hmm = phi_for_hmm - min_phi_hmm;
            [hmm_fitted_trace,z_hat,returnedErr,errmsg] = vbAnalysis(phi_for_analysis,num_states);      
%             phi_hmm = phi_hmm + min_phi_hmm;
            hmm_fitted_trace = hmm_fitted_trace + min_phi_hmm;
            molecule.hmm_phi_traces{1} = hmm_fitted_trace;
%             molecule.hmm_states = z_hat;
            len = length(molecule.hmm_phi_traces{1});
            curr_phi = molecule.hmm_phi_traces{1}(1);

%             molecule.step_sizes_AF1 = [];
%             molecule.step_sizes_AF2 = [];
%             molecule.step_sizes_AF3 = [];
%             molecule.step_sizes_AF4 = [];
%             molecule.step_sizes_AF5 = [];
%             molecule.step_sizes_AF6 = [];
%             
%             molecule.step_times_AF1 = [];
%             molecule.step_times_AF2 = [];
%             molecule.step_times_AF3 = [];
%             molecule.step_times_AF4 = [];
%             molecule.step_times_AF5 = [];
%             molecule.step_times_AF6 = [];

            for i=2:len
                next_phi = molecule.hmm_phi_traces{1}(i);
                if next_phi ~= curr_phi
                    step_size = next_phi - curr_phi;
                    curr_phi = next_phi;
                    curr_t = molecule.hmm_t_traces{1}(i);
                    % find segment in sequence info
                    for j=1:sequence_info.total_num_steps
                        interval = sequence_info.time_intervals(j,:);
                        if curr_t > interval(1) && curr_t < interval(2)
                            command_name = sequence_info.command_names_full_sequence{j};
%                             len_int = interval(2) - interval(1);
%                             if len_int == 60
                                % during flowsteps
                                AF_start_t = interval(1);
%                             else
%                                 AF_start_t = sequence_info.time_intervals(j-1,1);
%                             end
                            step_time = curr_t - AF_start_t;
%                             switch command_name
%                                 case 'AF1'
%                                     molecule.step_times_AF1 = [molecule.step_times_AF1; step_time];
%                                     molecule.step_sizes_AF1 = [molecule.step_sizes_AF1; step_size];
%                                 case 'AF2'
%                                     molecule.step_times_AF2 = [molecule.step_times_AF2; step_time];
%                                     molecule.step_sizes_AF2 = [molecule.step_sizes_AF2; step_size];
%                                 case 'AF3'
%                                     molecule.step_times_AF3 = [molecule.step_times_AF3; step_time];
%                                     molecule.step_sizes_AF3 = [molecule.step_sizes_AF3; step_size];
%                                 case 'AF4'
%                                     molecule.step_times_AF4 = [molecule.step_times_AF4; step_time];
%                                     molecule.step_sizes_AF4 = [molecule.step_sizes_AF4; step_size];
%                                 case 'AF5'
%                                     molecule.step_times_AF5 = [molecule.step_times_AF5; step_time];
%                                     molecule.step_sizes_AF5 = [molecule.step_sizes_AF5; step_size];
%                                 case 'AF6'
%                                     molecule.step_times_AF6 = [molecule.step_times_AF6; step_time];
%                                     molecule.step_sizes_AF6 = [molecule.step_sizes_AF6; step_size];
%                             end

                        end
                    end
                end
            end
        end

        
        if length(molecule.step_reactions) <120
            1;
        end
        %%%%%% keep this %%%%%%%%%
        molecules(mol) = molecule;
        waitbar(mol/num_mol,wait_bar,sprintf('performing extra calculations. molecule %d/%d', mol,num_mol));    

    end

    
    % ensemble calculations
%     if num_mol_selected>0
    if 0
        molecules_for_ensemble = get_molecules_from_selection(molecules,molecule_selection);
%         molecules_for_ensemble = molecules(molecule_selection);
        num_mol_ensemble = num_mol_selected;
%         num_mol_ensemble = length(molecules_for_ensemble);
    else
        molecules_for_ensemble = molecules;
        num_mol_ensemble = num_mol;
    end
    if num_mol_ensemble == 0
        return;
    end

    analysis.fuel_fittings = {};
    analysis.anti_fuel_fittings = {};
    num_fuel_commands = 0;
    num_anti_fuel_commands = 0;
    for i=1:sequence_info.total_num_steps

        interval = sequence_info.time_intervals(i,:);
        frame_start = round(interval(1)*framerate);    
        if i+1<=sequence_info.total_num_steps
            final_interval = sequence_info.time_intervals(i+1,:);
        else
            final_interval = sequence_info.time_intervals(i,:);
        end
        frame_end = round(final_interval(2)*framerate);
        frame_end = min(frame_end,vid_len);
        if frame_end == frame_start || frame_start == 0 || frame_end
            continue;
        end
        if frame_end<frame_start
            break;
        end
        command_name = sequence_info.command_names_full_sequence{i};
        fuel_group = get_fuel_group();
        anti_fuel_group = get_anti_fuel_group();
        switch command_name
            case fuel_group
                y = get_data(molecules_for_ensemble,num_mol_ensemble,'on_trace',frame_start,frame_end);
                y = mean(y,2);
                % going up from 0 to how much on
                optFunc = @increasing_exponent;
                options = optimset('lsqcurvefit');
                options = optimset(options, 'Jacobian','off', 'Display','off',  'TolX',10^-2, 'TolFun',10^-2, 'MaxPCGIter',1, 'MaxIter',500);
                lb = [min(y) max(y) 50];
                ub = [min(y) max(y) 2000];
                initialguess = [min(y) max(y) 100];
                t_seg = t(frame_start:frame_end);
                t_seg = t_seg - t_seg(1);
                t_seg = t_seg';
                [paramsFit, ~] = lsqcurvefit(optFunc,initialguess,t_seg,y,lb, ub, options);
                y_fit = increasing_exponent(paramsFit,t_seg);
                num_fuel_commands = num_fuel_commands + 1;
                analysis.fuel_fittings{num_fuel_commands} = {y_fit, paramsFit};

            case anti_fuel_group
                y = get_data(molecules_for_ensemble,num_mol_ensemble,'on_trace',frame_start,frame_end);
                y = mean(y,2);
                % going up from 0 to how much on
                optFunc = @decreasing_exponent;
                options = optimset('lsqcurvefit');
                options = optimset(options, 'Jacobian','off', 'Display','off',  'TolX',10^-2, 'TolFun',10^-2, 'MaxPCGIter',1, 'MaxIter',500);
                lb = [min(y) max(y) 0];
                ub = [min(y) max(y) 500];
                initialguess = [min(y) max(y) 10];
                t_seg = t(frame_start:frame_end);
                t_seg = t_seg - t_seg(1);
                t_seg = t_seg';
                [paramsFit, ~] = lsqcurvefit(optFunc,initialguess,t_seg,y,lb, ub, options);
                y_fit = decreasing_exponent(paramsFit,t_seg);
                num_anti_fuel_commands = num_anti_fuel_commands + 1;
                analysis.anti_fuel_fittings{num_anti_fuel_commands} = {y_fit, paramsFit};

%                 y_seg = decreasing_exponent(paramsFit,t_seg);
%                 figure
%                 plot(t_seg,y);
%                 hold on
%                 plot(t_seg,y_seg);
%                 1;
        end
    end

    % calculate based on d_phi
    [first_frame,last_frame,first_t,last_t] = get_timeframe(handles,analysis);
    t_seg = t(first_frame:last_frame);
    t_seg = t_seg';
    y = get_data(molecules_for_ensemble,num_mol_ensemble,'d_phi',first_frame,last_frame);
    y = mean(y,2);
    % going up from 0 to how much on
    optFunc = @decreasing_exponent;
    options = optimset('lsqcurvefit');
    options = optimset(options, 'Jacobian','off', 'Display','off',  'TolX',10^-2, 'TolFun',10^-2, 'MaxPCGIter',1, 'MaxIter',500);
    lb = [0 0 0];
    ub = [max(y) max(y) 1000];
    initialguess = [min(y) max(y) 300];
    [paramsFit, ~] = lsqcurvefit(optFunc,initialguess,t_seg,y,lb, ub, options);
    y_fit = decreasing_exponent(paramsFit,t_seg);
    analysis.fitting_d_phi = {y_fit, paramsFit};


    analysis.molecules = molecules;

    close(wait_bar);
    close(fig_fitting);

 








