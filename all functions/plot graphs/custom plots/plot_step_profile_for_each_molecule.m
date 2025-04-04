function plot_step_profile_for_each_molecule(handles,plot_info)

    molecules = plot_info.misc_molecules;
    sequence_info = plot_info.sequence_info;
    num_mol = plot_info.num_misc_mol;
    first_frame = plot_info.first_frame;
    last_frame = plot_info.last_frame;
    framerate = plot_info.framerate;
    t = plot_info.analysis.t;
    settings = handles.extra_calculations_settings;


    time_intervals = sequence_info.time_intervals;

    % try fake framerate
    framerate = framerate * 2;
    
    fuel_intervals = time_intervals(2:5,1);
    total_t_fuel_inc = max(fuel_intervals) - min(fuel_intervals);
    t_trace = 0:(1/framerate):total_t_fuel_inc;
    num_frames = length(t_trace);
    fraction_stepped = zeros(num_frames,1);
    


    f=figure;
    f.Position(2) = f.Position(2) * 0.5;
    ax = axes(f);

    for i=1:num_mol
        molecule = molecules(i);
        step_reactions = get_data_simple(molecule,'step_reactions');
        filtered_step_reactions = filter_step_reactions(step_reactions(:),1:6,0,inf,settings);
        step_times = get_data_simple(filtered_step_reactions,'relative_step_t_2');  
        step_times(step_times<0) = 0;
    
    
        % num 
        total_num_steps = length(step_times);
    
%         disp(total_num_steps);
    
    %     fraction_responded = length(not_inf) / length(imm_times);
        fraction_responded = 1;
        baseline = 0;
        
        step_times = sort(step_times);
        step_times(step_times <= 0.3) = 0.3;
    
    
        for i=1:num_frames
            curr_t = i/framerate;
            stepped_until_t = step_times(step_times<curr_t);
            num_stepped_until_t = length(stepped_until_t);
            fraction_stepped(i) = baseline + (fraction_responded) * (num_stepped_until_t/total_num_steps);
        end
    
    
%         hold(ax,'on');
%         plot(ax,t_trace',fraction_stepped,'LineWidth',2);

        % fit to custom function
        x = t_trace';
        y = fraction_stepped;
    
        N = length(step_times);
    
        my_fit_double_exponent(ax,x,y,N);

    end



    ax.FontSize = 14;
    ax.FontWeight = 'bold';
    ax.YLim = [0 1];
    ax.XLabel.String = 't (sec)';
    ax.YLabel.String = 'fraction of steps completed';
    f.Color = [1 1 1];

    ax.XGrid = 'on';
    ax.YGrid = 'on';
    ax.YTick = 0:0.1:1;

%     l = legend({'1->3','2->4','3->5','4->6','5->1','6->2'});
%     l.Location = 'NorthEastOutside';


    export = 0;
    if export
        file_metadata = get_current_file_metadata(handles);
        path_name = file_metadata.pathname;
        filename = file_metadata.filename;
        export_path = path_name;
        str_export = [export_path '\' filename '_stepping_profile' '.xlsx'];
    
        matrix = [t_trace' fraction_stepped];
        writematrix(matrix,str_export);
    
        disp('export finished');
    end




    








