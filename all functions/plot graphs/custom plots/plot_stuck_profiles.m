function plot_stuck_profiles(handles,plot_info)

    molecules = plot_info.misc_molecules;
    sequence_info = plot_info.sequence_info;
    num_mol = plot_info.num_misc_mol;
    first_frame = plot_info.first_frame;
    last_frame = plot_info.last_frame;
    framerate = plot_info.framerate;
    t = plot_info.analysis.t;
    

    time_intervals = sequence_info.time_intervals;

    counter = 0;
    % iterate x segments of fuel, not including antifuel -> 1->5, 61->65, etc
   
    f=figure;
    ax = axes(f);
    for i=1:60:sequence_info.total_num_steps
        if counter == 1
%             break;
        end
        
        % take F2 - 11->15
        frame_start = round(time_intervals(i+11) * framerate);
        frame_end = round(time_intervals(i+14) * framerate);


        % take F3 - 11->15
%         frame_start = round(time_intervals(i+21) * framerate);
%         frame_end = round(time_intervals(i+24) * framerate);

        % take AF2 - 16->20
%         frame_start = round(time_intervals(i+15) * framerate);
%         frame_end = round(time_intervals(i+19) * framerate);


        if frame_start > last_frame || frame_end > last_frame
            break;
        end
        stuck_traces = get_data(curr_molecules,num_mol,'stuck_trace',frame_start,frame_end);
        avg_stuck = mean(stuck_traces,2);
        if i == 1
            t_trace = t(frame_start:frame_end) - t(frame_start);
            combined_trace = zeros(length(avg_stuck),1);
        end
        combined_trace(1:length(avg_stuck)) = combined_trace(1:length(avg_stuck)) + avg_stuck;
        counter = counter + 1;
        
%         hold(ax,'on');
%         plot(ax,avg_stuck);
    end
    disp(counter);
    combined_trace = combined_trace / counter;
    hold(ax,'on');
    plot(ax,t_trace,combined_trace,'LineWidth',2);
    ax.FontSize = 14;
    ax.FontWeight = 'bold';
    ax.YLim = [0 1];
    ax.XLabel.String = 't (sec)';
    ax.YLabel.String = 'fraction immobile';
    f.Color = [1 1 1];

    export = 0;
    if export
        file_metadata = get_current_file_metadata(handles);
        path_name = file_metadata.pathname;
        filename = file_metadata.filename;
        export_path = path_name;
        str_export = [export_path '\' filename '_stuck_trace' '.xlsx'];
    
        matrix = [t_trace' combined_trace];
        writematrix(matrix,str_export);
    
        disp('export finished');
    end

    % fit to custom function
    x = t_trace';
    y = combined_trace;

    my_fit(ax,x,y);







