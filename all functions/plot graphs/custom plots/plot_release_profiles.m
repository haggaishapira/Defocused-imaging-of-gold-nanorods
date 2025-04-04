function plot_release_profiles(handles,plot_info)

    molecules = plot_info.misc_molecules;
    sequence_info = plot_info.sequence_info;
    num_mol = plot_info.num_misc_mol;
    first_frame = plot_info.first_frame;
    last_frame = plot_info.last_frame;
    framerate = plot_info.framerate;
    t = plot_info.analysis.t;
    

    time_intervals = sequence_info.time_intervals;


    f=figure('Color',[1 1 1]);
    f.Position(2) = f.Position(2)  * 0.5;
    ax = axes(f);


    for anti_fuel_num = 1:6
        fuel_intervals = time_intervals(2:5,1);
        total_t_fuel_inc = max(fuel_intervals) - min(fuel_intervals);
        t_trace = 0:(1/framerate):total_t_fuel_inc;
        num_frames = length(t_trace);
        fraction_released = zeros(num_frames,1);
        
        release_reactions = get_data_simple(molecules,'release_reactions');
        release_reactions = get_release_reactions_specific_anti_fuel_and_time(release_reactions(:),anti_fuel_num,0,inf);
        rel_times = get_data_simple(release_reactions,'relative_release_time');
        rel_times = sort(rel_times);
        not_inf = rel_times(~isinf(rel_times));
    
%         disp(length(not_inf));

        % num 
        num_responded = length(not_inf);
%         fraction_responded = length(not_inf) / length(rel_times);
        fraction_responded = 1;
%         baseline = 0.25;
        baseline = 0;
        

        disp(anti_fuel_num);
        disp(num_responded);


        for i=1:num_frames
            curr_t = i/framerate;
            responded_until_t = not_inf(not_inf<curr_t);
            num_responded_until_t = length(responded_until_t);
            fraction_released(i) = baseline + (fraction_responded) * (num_responded_until_t/num_responded);
        end
    
%         hold(ax,'on');
%         plot(ax,t_trace',fraction_immobile,'LineWidth',2);

        % fit to custom function
        x = t_trace';
        y = fraction_released;
    
        my_fit(ax,x,y);
    end


    ax.FontSize = 20;
    ax.FontWeight = 'bold';
    ax.YLim = [0 1];
    ax.XLabel.String = 'Time (s)';
    ax.YLabel.String = 'Fraction released';
    f.Color = [1 1 1];

    l = legend({'AF1','AF2','AF3','AF4','AF5','AF6'});
%     l = legend({'F3','F4','F5','F6','F1','F2'});
    l.Location = 'NorthEastOutside';


    
    col1 = [0, 0.4470, 0.7410];
    col2 = [0.8500, 0.3250, 0.0980];
    col3 = [0.9290, 0.6940, 0.1250];
    col4 = [0.4940, 0.1840, 0.5560];
    col5 = [0.4660, 0.6740, 0.1880];
    col6 = [0.3010, 0.7450, 0.9330];

    cols = [col5; col6; col1; col2; col3; col4];
    cols = flipud(cols);

    for i=1:6
        ax.Children(i).Color = cols(i,:);
    end




    export = 0;
    if export
        file_metadata = get_current_file_metadata(handles);
        path_name = file_metadata.pathname;
        filename = file_metadata.filename;
        export_path = path_name;
        str_export = [export_path '\' filename '_immobilized_trace' '.xlsx'];
    
        matrix = [t_trace' fraction_released];
        writematrix(matrix,str_export);
    
        disp('export finished');
    end












