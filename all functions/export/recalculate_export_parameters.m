function handles = recalculate_export_parameters(handles)

    [file_metadata,file_num] = get_current_file_metadata(handles);
    real_framerate = file_metadata.framerate;

    mode = handles.export_settings.mode;

    first_t = str2num(handles.export_first_t.String);
    last_t = str2num(handles.export_last_t.String);
    

    t_movie = last_t-first_t;

%     export_video_framerate = 20;
    export_video_framerate = 1/0.08;
    

    % interval is in time (sec), not frames

%     mode = 1;
    switch mode
        case 1
            % by interval - DONT USE THIS
%             return;
            time_interval = str2num(handles.export_video_interval.String);
            num_frames = t_movie / time_interval;
            duration = num_frames / export_video_framerate;
            handles.export_video_duration.String = num2str(duration);
        case 2
            % by video duration
            duration = str2num(handles.export_video_duration.String);
            num_frames = duration * export_video_framerate;            
            time_interval = t_movie / num_frames;
            % number of frames could be too much
            time_interval = max(time_interval,1/real_framerate);
            
            frame_interval = round(time_interval * real_framerate);
            handles.export_video_interval.String = num2str(frame_interval);
            

    end
%     duration = round(duration,2);
%     time_interval = round(time_interval,2);

    % frame interval

%     handles.export_video_duration.String = num2str(duration);
    









    