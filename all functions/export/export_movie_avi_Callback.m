function export_movie_avi_Callback(hObject, eventdata, handles)
    clc
%     path = handles.pathname.String;
%     filename = handles.filename.String;
    
    [file_metadata,file_num] = get_current_file_metadata(handles);

% 
    pathname = file_metadata.pathname;
    filename = file_metadata.filename;

    vid_len = file_metadata.vid_len;

    analysis = get_current_analysis(handles);
    num_mol = analysis.num_mol;

    mol = handles.molecule_list.Value;
    if num_mol>0     
        molecule = analysis.molecules(mol);   
        mol_extension = ['_' molecule.str];
    end

    settings = handles.export_settings;
    export_settings_mat = cell2mat(struct2cell(settings));
    if isempty(find(export_settings_mat))
        msgbox('none selected');
        return;
    end

%     export_framerate = 12.5;
    export_framerate = 1/0.08;
%     framerate = 8.65;

%     analysis = get_current_analysis(handles);
    
%     settings.export_raw_video = 0;
%     settings.export_analysis_video = 0;
%     settings.export_raw_ROI = 0;
%     settings.export_analysis_ROI = 0;
%     settings.export_trace_sm = 0;
%     settings.export_trace_ens = 0;
%     settings.export_polar_hist = 0;
%     settings.export_linear_hist = 0;

    export_raw_video = settings.export_raw_video;
    export_analysis_video = settings.export_analysis_video;
    export_raw_ROI = settings.export_raw_ROI;
    export_analysis_ROI = settings.export_analysis_ROI;
    export_trace_sm = settings.export_trace_sm;
    export_trace_ens = settings.export_trace_ens;
    export_polar_hist = settings.export_polar_hist;
    export_linear_hist = settings.export_linear_hist;
    export_fitting = settings.export_fitting;
    export_3d = settings.export_3d;
        
    mkdir(pathname, [filename ' recording\']);
    final_pathname = [pathname '\' filename ' recording\'];
%     final_pathname = [path '\' filename];
    
%     final_pathname = [subfolder_path '\' filename '.tiff'];
%     mol = handles.molecule_list.Value;
%     final_pathname = [final_path '\' filename '_mol' num2str(mol) '.tiff'];
%     writerObj_all = VideoWriter(final_pathname, 'Uncompressed AVI');

%

%     mol_extension = ['_mol' num2str(mol)];

    if export_raw_video
        name_raw_video = [final_pathname 'raw_full_video'];
        writerObj_raw_full_video = VideoWriter(name_raw_video);
        writerObj_raw_full_video.FrameRate = export_framerate;
        open(writerObj_raw_full_video);
    end
    if export_analysis_video
        filename = [final_pathname 'analysis_full_video'];
        writerObj_analysis_full_video = VideoWriter(filename);  
        writerObj_analysis_full_video.FrameRate = export_framerate;
        open(writerObj_analysis_full_video);
    end
    if export_raw_ROI
        filename = [final_pathname 'raw_ROI_video' mol_extension];
        writerObj_raw_ROI_video = VideoWriter(filename,'Uncompressed AVI');
        writerObj_raw_ROI_video.FrameRate = export_framerate;
        open(writerObj_raw_ROI_video);
        ROI_fig = figure;
        ax_ROI = axes(ROI_fig);
    end
    if export_analysis_ROI
        filename = [final_pathname 'analysis_ROI_video' mol_extension];
        writerObj_analysis_ROI_video = VideoWriter(filename);
        writerObj_analysis_ROI_video.FrameRate = export_framerate;
        open(writerObj_analysis_ROI_video);
    end 
    if export_trace_sm
        trace_sm_type_num = handles.choose_trace_sm.Value;
        trace_sm_type_str = handles.choose_trace_sm.String{trace_sm_type_num};
        filename = [final_pathname trace_sm_type_str mol_extension];
        writerObj_trace_sm = VideoWriter(filename);
        writerObj_trace_sm.FrameRate = export_framerate;
        open(writerObj_trace_sm);
    end
    if export_trace_ens
        trace_ens_type_num = handles.choose_trace_ensemble.Value;
        trace_ens_type_str = handles.choose_trace_ensemble.String{trace_ens_type_num};
        filename = [final_pathname trace_ens_type_str];
        writerObj_trace_ens = VideoWriter(filename);
        writerObj_trace_ens.FrameRate = export_framerate;
        open(writerObj_trace_ens);
    end
    if export_polar_hist
        polar_hist_type_num = handles.choose_hist_polar.Value;
        polar_hist_type_str = handles.choose_hist_polar.String{polar_hist_type_num};
        filename = [final_pathname 'polar hist - ' polar_hist_type_str];
        
        writerObj_polar_hist = VideoWriter(filename);
        writerObj_polar_hist.FrameRate = export_framerate;
        open(writerObj_polar_hist);
%         full_figure = getframe(handles.figure1);
%         full_figure = frame2im(full_figure);
%         frame = full_figure(180:500,1550:end-30,:);
%         imwrite(frame,filename,'tiff');  
%         disp('image saved');
        
    end
    if export_linear_hist
%         linear_hist_type_num = handles.choose_trace_sm.Value;
%         linear_hist_type_str = handles.choose_trace_sm.String{linear_hist_type_num};
%         filename = [final_pathname '_' linear_hist_type_str];
%         writerObj_linear_hist = VideoWriter(filename);
%         writerObj_linear_hist.FrameRate = framerate;
%         open(writerObj_linear_hist);
    end    

    if export_fitting
        filename = [final_pathname 'fitting'];
        writerObj_fitting = VideoWriter(filename);
        writerObj_fitting.FrameRate = export_framerate;
        open(writerObj_fitting);
    end

    if export_3d
        filename = [final_pathname 'fitting'];
        writerObj_fitting = VideoWriter(filename);
        writerObj_fitting.FrameRate = export_framerate;
        open(writerObj_fitting);
    end


    if ~export_raw_video && ...
       ~export_analysis_video && ...
       ~export_raw_ROI && ...
       ~export_analysis_ROI && ...
       ~export_trace_sm && ...
       ~export_trace_ens && ...
       ~export_polar_hist && ...
       ~export_fitting && ...
       ~export_3d
       return;
    end
    
    first_t = str2num(handles.export_first_t.String);
    last_t = str2num(handles.export_last_t.String);

    real_framerate = file_metadata.framerate;

    first_frame = round(first_t*real_framerate);
    first_frame = max(first_frame,1);
    last_frame = round(last_t*real_framerate);
    last_frame = min(last_frame,vid_len);


%     first_frame = str2num(handles.export_first_frame.String);
%     last_frame = str2num(handles.export_last_frame.String);


%     len = last_frame - first_frame + 1;
    

    
    frame_interval = str2num(handles.export_video_interval.String);
%     frame_interval = time_interval * real_framerate;
%     frame_interval = round(frame_interval);
%     frame_interval = max(frame_interval,1);

%     frame_nums = [100:600 2970:3500];
%     frame_nums = [80:1000];
%     frame_nums = [190:600 2079:3000];
%     frame_nums = [190:3000];
%     num_frames_total = length(frame_nums);

%     do first x frames y times
% x_frames = 3;
% y_times = 10;

    % iterate movie here
%     for i= [1 1 1 1 1 1 1 1 1 2:last_frame]
    for i=first_frame:frame_interval:last_frame
%     for i=1:num_frames_total
%         if mod(i,4)
%             continue;
%         end
%         drawnow;
        if getappdata(0,'stop')
            setappdata(0,'stop',0);
            break;
        end
        
%         if export_analysis_full_video || export_analysis_ROI_video || export_trace_sm || export_trace_ens
        handles.listener_switch.Value = 0;
        handles.listener.Enabled = 0;
        handles.slider_frames.Value = i;
        handles.listener_switch.Value = 1;
        handles.listener.Enabled = 1;
%         handles.slider_frames.Value = frame_nums(i);
%         init = i == 1;
        init = 0;
        handles = frame_changed(handles,init,0);
%         drawnow;
%         else
%             [handles,raw_frame] = get_frame(handles);
%         end
        full_figure = getframe(handles.figure1);
        full_figure = frame2im(full_figure);
        
        if export_raw_video
%             [handles,frame] = get_frame(handles);
            frame = handles.frame;
            frame = convert_frame_to_save_format(frame);
            writeVideo(writerObj_raw_full_video, frame);
        end
        if export_analysis_video
            frame = getframe(handles.ax_video);
            frame = frame2im(frame);
%             analysis_full_frame = full_figure(250:500,800:1335,:);
            writeVideo(writerObj_analysis_full_video, frame);
        end
        if export_raw_ROI
            frame = handles.frame;
            ROI = molecule.ROI(:,i);
            frame = get_ROI_im(ROI,frame);
%             frame = imresize(frame,50);
%             frame = convert_frame_to_save_format(frame);
            if i == first_frame
                imagesc(ax_ROI,frame);
                colormap(ax_ROI,gray(50));
            else
                ax_ROI.Children.CData = frame;
            end
            frame = getframe(ROI_fig);
            frame = frame.cdata;
            frame = frame(33:373,75:506,:);
            writeVideo(writerObj_raw_ROI_video, frame);
        end        
        if export_analysis_ROI
%             analysis_ROI_frame = full_figure(20:200,850:1050,:);
            frame = getframe(handles.ax_ROI);
            frame = frame2im(frame);
            writeVideo(writerObj_analysis_ROI_video, frame);
        end
        if export_trace_sm
%             trace_sm_frame = full_figure(210:480,780:1320,:);
%             trace_sm_frame = full_figure(290:720,1150:2000,:);
%             trace_sm_frame = full_figure(160:383,625:1065,:);

%           laptop
            trace_sm_frame = full_figure(205:495,780:1325,:);
            % large screen
%             trace_sm_frame = full_figure(190:390,650:1060,:);
            writeVideo(writerObj_trace_sm, trace_sm_frame);
        end
        if export_trace_ens
            trace_ens_frame = full_figure(500:750,800:1335,:);
%             trace_ens_frame = full_figure(380:570,625:1065,:);
            writeVideo(writerObj_trace_ens, trace_ens_frame);
        end
        if export_polar_hist
            % get molecule area
%             frame = full_frame(250:500,800:1335,:);
            frame = full_figure(180:500,1550:end-30,:);
            writeVideo(writerObj_polar_hist, frame);
        end
        if export_linear_hist
            % get molecule area
%             ROI_im = full_frame(250:500,800:1335,:);
%             writeVideo(writerObj_trace_sm, trace_sm_frame);
        end
        if export_fitting
            frame = getframe(handles.ax_fitting_pattern);
            frame = frame2im(frame);
            writeVideo(writerObj_fitting, frame);
        end
        if export_3d
            frame = getframe(handles.ax_3d);
            frame = frame2im(frame);
            writeVideo(writerObj_3d, frame);
        end

        
    end
    
    if export_raw_video
        close(writerObj_raw_full_video);
    end
    if export_analysis_video
        close(writerObj_analysis_full_video);
    end
    if export_raw_ROI
        close(writerObj_raw_ROI_video);
        close(ROI_fig);
    end
    if export_analysis_ROI
        close(writerObj_analysis_ROI_video);
    end
    if export_trace_sm
        close(writerObj_trace_sm);
    end
    if export_trace_ens
        close(writerObj_trace_ens);
    end
    if export_polar_hist
        close(writerObj_polar_hist);
    end
    if export_linear_hist
%         close(writerObj_linear_hist);
    end

%     msgbox('export finished');
    disp('export finished');

    update_handles(handles.figure1, handles);
