function plot_info = initialize_plot_info(handles,acquisition,initialize_all,analysis,plot_info)

    plot_settings = handles.plot_settings;
    use_selected_molecules = 0;
%     apply_filters = handles.apply_filters.Value;
    
    plot_info.acquisition = acquisition;
    plot_info.analysis = analysis;

    if acquisition
        current_molecules = analysis.molecules;
        num_mol_curr = analysis.num_mol;
    else
        [current_molecules,num_mol_curr] = get_current_molecules(handles);
    end

    plot_info.all_curr_mol = current_molecules;
    plot_info.num_all_mol_curr = num_mol_curr;


    molecule_selection = get_current_molecule_selection(handles);
    
    % molecule - curr,all,files?
    
    if num_mol_curr>0
        % single molecule selection
        disp_mol_index = get_disp_mol_index(handles);
        plot_info.disp_mol_index = disp_mol_index;
        plot_info.disp_mol = current_molecules(disp_mol_index); 
        single_molecule_selection = plot_info.disp_mol.num;

         % ensemble selection
        val = handles.choose_molecule_selection_type.Value;
        molecule_selection_type = handles.choose_molecule_selection_type.String{val};
        all_molecules = cell2mat({current_molecules.num});
        use_selected_molecules = 0;
        switch molecule_selection_type
            case 'all molecules'
                ensemble_selection = all_molecules;
            case 'selected molecules'
                ensemble_selection = molecule_selection;
                use_selected_molecules = 1;
            case 'non-selected molecules'
                ensemble_selection = setdiff(all_molecules,molecule_selection);
        end
    else
        single_molecule_selection = [];
        ensemble_selection = [];
    end

   

%     [plot_info.curr_mol,plot_info.num_mol_curr] = get_molecules_from_selection(current_molecules,ensemble_selection);
    [plot_info.curr_mol,plot_info.num_mol_curr] = get_molecules_from_selection(current_molecules,ensemble_selection);

    % file
    val = handles.choose_file_selection_type.Value;
    file_selection_type = handles.choose_file_selection_type.String{val};
    
    % misc molecule selection
    val = handles.choose_sm_or_ens.Value;
    sm_or_ens = handles.choose_sm_or_ens.String{val};
    switch sm_or_ens
        case 'single molecule'
            misc_molecule_selection = single_molecule_selection;
        case 'ensemble'
            misc_molecule_selection = ensemble_selection;
    end

    if acquisition
%         plot_info.misc_molecules = current_molecules;
%         plot_info.num_misc_mol = num_mol_curr;
        [plot_info.misc_molecules,plot_info.num_misc_mol] = get_molecules_from_selection(current_molecules,misc_molecule_selection);                   
    else
        switch file_selection_type
            case 'current file'
                [molecules,~] = get_current_molecules(handles);
                [plot_info.misc_molecules,plot_info.num_misc_mol] = get_molecules_from_selection(molecules,misc_molecule_selection);                   
            case 'all files'
%                 get_selection = 0;
                file_selection = 1:handles.num_files;
%                 [plot_info.misc_molecules,plot_info.num_misc_mol] = get_all_molecules(handles);
                [plot_info.misc_molecules,plot_info.num_misc_mol] = get_molecules_from_files(handles,file_selection,use_selected_molecules);
            case 'selected files'
                file_selection = handles.file_list.Value;
                [plot_info.misc_molecules,plot_info.num_misc_mol] = get_molecules_from_files(handles,file_selection,use_selected_molecules);
        end

%         if apply_filters
%             [plot_info.misc_molecules,plot_info.num_misc_mol] = filter_molecules(handles,plot_info.misc_molecules,plot_info.num_misc_mol);
%         end


        handles.num_misc_mol.String = num2str(plot_info.num_misc_mol);
    end
    plot_info.vid_len = analysis.vid_len;
    curr_frame = round(handles.slider_frames.Value);
    plot_info.curr_frame = curr_frame;

%     fprintf('%d misc molecules.\n',plot_info.num_misc_mol);
    
    plot_info.curr_t = analysis.t(plot_info.curr_frame);
     

    [first_frame,last_frame,first_t,last_t] = get_timeframe(handles,analysis);

    if ~isinf(last_t)
        last_t = min(last_t,analysis.vid_len/analysis.framerate);
    end
    
%%%     min_last_frame temp code
    if strcmp(file_selection_type,{'selected files','all files'})
        min_last_frame = inf;
        if handles.num_files > 0
            analyses = handles.analyses;
            num_files_selected = length(file_selection);
            for i=1:num_files_selected
                file_num = file_selection(i);
                last_frame = length(analyses(file_num).t);
                min_last_frame = min(min_last_frame,last_frame);
            end
        end
        last_frame = min_last_frame;
    end

    if getappdata(0,'acquisition')
        last_frame = curr_frame;
        last_t = plot_info.curr_t;
    end

    plot_info.first_frame = first_frame;
    plot_info.last_frame = last_frame;
    plot_info.first_t = first_t;
    plot_info.last_t = last_t;

    if initialize_all
        plot_info.current_plots = {'' '' '' '' ''};
    else
        plot_info.current_plots = handles.current_plots;
    end

    trace_sm_type_num = handles.choose_trace_sm.Value;
    trace_sm_type_str = handles.choose_trace_sm.String{trace_sm_type_num};
    trace_ensemble_type_num = handles.choose_trace_ensemble.Value;
    trace_ensemble_type_str = handles.choose_trace_ensemble.String{trace_ensemble_type_num};
    hist_polar_type_num = handles.choose_hist_polar.Value;
    hist_polar_type_str = handles.choose_hist_polar.String{hist_polar_type_num};
    hist_linear_type_num = handles.choose_hist_linear.Value;
    hist_linear_type_str = handles.choose_hist_linear.String{hist_linear_type_num};
    output_number_type_num = handles.choose_output_number.Value;
    output_number_type_str = handles.choose_output_number.String{output_number_type_num};
    
    plot_info.new_plots = {trace_sm_type_str trace_ensemble_type_str hist_polar_type_str hist_linear_type_str output_number_type_str};


    plot_info.reaction_timings = get_reaction_timings(handles);
    
%     plot_info.combine_statistics = handles.combine_statistics.Value;
    plot_info.combine_statistics = 0;
    

%     registered_phi_states = handles.registered_phi_states;
%     plot_info.registered_phi_states = registered_phi_states;
 
    [sequence_info,~] = get_current_sequence_info(handles);
    plot_info.sequence_info = sequence_info;
    plot_info.plot_sequence = ~sequence_info.empty;

    
%     plot_info.plot_sequence = handles.general_settings.plot_sequence;
    plot_info.plot_sequence = handles.plot_sequence.Value;
%     plot_info.plot_sequence = 0;

    fuel_group = get_fuel_group();
    anti_fuel_group = get_anti_fuel_group();

    if plot_info.plot_sequence
        % command colors        
        command_colors = zeros(sequence_info.total_num_steps,4);
        for i=1:sequence_info.total_num_steps
            alpha = 0.2;
            command_name = sequence_info.command_names_full_sequence{i};
            if isempty(command_name) && i>1
                command_name = sequence_info.command_names_full_sequence{i-1};
%                 command_name = 'empty';
            end
            switch command_name
                case 'empty'
                    col = [0.5 0.5 0.5];
                case '102'
                    col = [0.5 0.5 0.5];
                case fuel_group
                    col = [0 1 0];
%                     col = 0.6*[0 1 0];
                case anti_fuel_group                   
                    col = [1 0 0];
                case 'biotin'
                    col = 0.8*[1 1 0];
                case 'NaCl 1M'
                    col = [0 0 1];
                case 'AS'
                    col = 0.7*[1 1 0];
                otherwise
                    col = [0 0 0];
                    alpha = 0;
            end
            interval = sequence_info.time_intervals(i,:);
            len = interval(2) - interval(1);
            if i>1 && len <= 30
                col = command_colors(i-1,1:3);
                alpha = command_colors(i-1,4);
            end
            command_colors(i,:) = [col alpha];
        end
        plot_info.command_colors = command_colors;
    end

    % frames to take
    val = handles.choose_frame_selection_type.Value;
    frame_selection_type = handles.choose_frame_selection_type.String{val};

    plot_info.misc_molecule_frames = {};
    misc_molecules = plot_info.misc_molecules;
    num_mol = size(misc_molecules,2);
    for i=1:num_mol
        molecule = misc_molecules(i);
        if acquisition
%             first = 1;
%             last = plot_info.last;
%             disp(plot_info.last);

%             last = length(molecule.phi_half);
        else
%             if strcmp(file_selection_type,'current file')
%                 [first,last] = get_timeframe(handles,analysis);
%             else
%                 first = round(10 * analysis.framerate);
%                 first = round(10 * analysis.framerate);
%                 last = length(molecule.phi_half);
%             end
        end
        frames = get_molecule_frames...
            (handles,analysis,molecule,frame_selection_type,curr_frame,first_frame,last_frame);
        plot_info.misc_molecule_frames{i} = frames;
    end

    plot_info.framerate = analysis.framerate;    
    framerate = analysis.framerate;
    t = 10;
    frame_num = round(t*framerate) + 1;
    plot_info.plot_reference_frame_num = frame_num;

    plot_info.ens_fitting = [];

    plot_info.transform = get_transform_arr(num_mol_curr);

    plot_info.hour_scale = handles.general_settings.hour_scale;

    plot_info.delta_phi = str2num(handles.delta_phi.String); 
    







    