function [handles,file_num] = apply_file_metadata(handles,file_metadata,add_new)

    [pathname, filename, extension] = fileparts(file_metadata.full_name);
    handles.pathname.String = pathname;
%     if reset_filename
%         handles.filename.String = filename;
%     end
    handles.extension = extension;

    if add_new
        handles.num_files = handles.num_files + 1;
        file_num = handles.num_files;
        handles.file_list.String{file_num} = filename;
        handles.file_list.Max = handles.num_files;
        handles.file_metadatas = [handles.file_metadatas; file_metadata];
        handles.current_file_num = file_num;
    else
        file_num = handles.current_file_num;
    end
    
%     handles.file_list.Value = file_num;
%     handles.current_filename = file.full_name;
%     handles.filename_read_tif = file.full_name;
%     handles.tif_object = Tiff(handles.filename_read_tif, 'r');
    vid_len = file_metadata.vid_len;
    handles.vid_len = vid_len;
    
    handles.duration_output.String = num2str(file_metadata.duration);
    handles.framerate.String = num2str(file_metadata.framerate);
    handles.vid_len_output.String = num2str(file_metadata.vid_len);
 
%     val = handles.listener_switch.Value;
%     val = handles.listener.Enabled;
%     handles.listener.Enabled = 0;
%     handles.listener_switch.Value = 0;

%     drawnow
    update_handles(handles.figure1,handles); %???

    general_settings = handles.general_settings;
    default_first_t = general_settings.default_first_t;
    default_last_t = general_settings.default_last_t;

    if handles.slider_frames.Value > vid_len
        if file_metadata.duration > default_first_t
            t_start = min(default_first_t,file_metadata.duration);
            framerate = file_metadata.framerate;
            frame_start = round(t_start*framerate);
            frame_start = max(frame_start,1);
        else
            frame_start = 1;
        end
        handles.slider_frames.Value = frame_start;
    end
    set(handles.slider_frames,'Min',1,'Max',vid_len,'SliderStep',[1/(vid_len-1) 1/(vid_len-1)]);
%     handles.listener.Enabled = val;


%     skip = str2num(handles.skip_frames.String);
    handles.slider_frames.SliderStep = (handles.slider_frames.SliderStep) * 1;
    handles.skip_frames.String = num2str(1);

%     first_t = num2str(0);
    first_t = default_first_t;
    last_t = default_last_t;
%     last_t = file_metadata.duration;
%     last_t = round(last_t,2);

    handles.export_first_t.String = num2str(first_t);
    handles.export_last_t.String = num2str(last_t);

    handles.export_video_duration.String = num2str(last_t);

    % current time frame


    curr_first_t = str2num(handles.first_t.String);
    curr_last_t = str2num(handles.last_t.String);

    if curr_last_t < file_metadata.duration
        last_t = curr_last_t;
    end
%     last_t = min(curr_last_t,file_metadata.duration);
    if curr_first_t < file_metadata.duration && curr_first_t < last_t
        first_t = curr_first_t;
    end

    % correct for segment stuff
    if handles.set_segment.Value
        % number of segments
        [sequence_info,file_num] = get_current_sequence_info(handles);
        if ~sequence_info.empty
            num_seg = length(sequence_info.command_names_full_sequence);
            handles.min_seg.String = num2str(1);
            handles.max_seg.String = num2str(num_seg);
            first_t = sequence_info.time_intervals(1,1);
            last_t = sequence_info.time_intervals(num_seg,2);
            last_t = min(last_t,file_metadata.duration);
        end
    end


    handles.first_t.String = num2str(first_t);
    handles.last_t.String = num2str(last_t);
    
    handles.molecule_list.String = cell(0,1);

    handles = recalculate_export_parameters(handles);











