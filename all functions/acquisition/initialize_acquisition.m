function [handles,acq,error] = initialize_acquisition(handles,acq)

    acq.live_analysis = handles.live_analysis.Value;
    acq.autosave = handles.autosave.Value;

    if ~acq.limited
        acq.autosave = 0;
        acq.live_analysis = 0;
    end  
    error = 0;

    handles.stop_acquisition.Value = 0;

%     analysis_settings = handles.analysis_settings;
    acquisition_settings = handles.acquisition_settings;

    acq.synthetic = acquisition_settings.synthetic;
    if acq.synthetic
        default_path = handles.pathname.String;
        default_path = fullfile(default_path,'*.tif;*.fits');

%         [filename,pathname] = uigetfile([default_path '\*.fits'], 'select video file for synthetic acquisition');
        [filename,pathname] = uigetfile(default_path, 'select video file for synthetic acquisition');
        if ~filename
            error = 1;
            return;
        end 
        acq.path_synthetic = [pathname filename];
        handles.pathname.String = pathname;
%         handles.filename.String = filename;
% %         vid_len = 
%         [~,~,extension] = fileparts(acq.path_synthetic);
%         if strcmp(extension,'.tif')
            acq.tif_object = Tiff(acq.path_synthetic, 'r');
%             handles = load_video(handles,filename,pathname);
%         end
    end

    % initialize name here so sequence can also get it
    filename = handles.filename.String;
    acq.path = handles.pathname.String;
    time_str = clock_to_string();
    filename_sequence = [acq.path '\' time_str '_' filename '_sequence_labview.txt'];

    acq.trigger_microfluidics = 0;

    acq.sequence_info = make_empty_sequence_info();
    if acq.live_analysis
        % microfluidics trigger
        connected_to_microfluidics = handles.microfluidics_connected;
        trigger_microfluidics = handles.trigger_microfluidics.Value;
        acq.trigger_microfluidics = trigger_microfluidics;
        
        
        if trigger_microfluidics && ~connected_to_microfluidics
            msgbox('cannot trigger, microfluidics disconnected. aborting acquisition.');
            error = 1;
            return;
        end
%         if trigger_microfluidics && ~acq.live_analysis
%             msgbox('not triggering if not in live analysis mode.'); %% live analysis is now necessary for piezo z correction
%             error = 1;
%             return;
%         end
    
        conn = handles.microfluidics_connection;
%         trigger_microfluidics = 1;
        if trigger_microfluidics
            % get sequence
            flush(conn);
            response_ok = send_message_and_test_response(conn,'3');
            if ~response_ok
                msgbox('microfluidics not responsive, aborting acquisition.'); 
                error = 1;
                return;
            end
            
            if handles.microfluidics_settings.load_sequence_on_trigger
                sequence_info = read_sequence_info_3(handles,filename_sequence);
                acq.sequence_info = sequence_info;

                % replace input duration
                if handles.microfluidics_settings.overwrite_measurement_time
                    handles.duration_input.String = num2str(sequence_info.total_time);
                end
            end
        end
    end


    acq.gain = acquisition_settings.gain;
    acq.binning = acquisition_settings.binning;
    
    if acq.limited
        acq.kinetic_cycle_time = acquisition_settings.kinetic_cycle_time;
    else
        acq.kinetic_cycle_time = 0.04;
    end
    acq.exposure_time = acquisition_settings.exposure_time;
    acq.bits_per_pixel = 16;


    delete(findall(handles.figure1,'type','annotation'));
    delete(findall(handles.figure1,'type','text'));
    update_handles(handles.figure1,handles);
    
    handles.molecule_list.Value = 1;  
    handles.molecule_list.String = {};

    handles.selected_molecules_list.Value = 1;  
    handles.selected_molecules_list.String = {};

    handles.curr_mol_num = 1;
    
%     live_analysis = handles.live_analysis.Value;
%     autosave = handles.autosave.Value;

       
    abort_acquisition(0);

    acq.spool = acq.autosave || acq.live_analysis;    

    ret = SetFrameTransferMode(acquisition_settings.frame_transfer);
    CheckWarning(ret);
    
    drive_not_initialized = ret == 20075;
    if drive_not_initialized && ~acq.synthetic
        msgbox('camera not connected properly.');
        error = 1;
        return;
    end

    % these apply to both pre-acquisition (for analysis) and main acquisition
    [ret] = SetEMCCDGain(acq.gain);
    CheckWarning(ret);
    [ret] = SetKineticCycleTime(acq.kinetic_cycle_time);
    CheckWarning(ret);
    [ret] = SetExposureTime(acq.exposure_time);
    CheckWarning(ret);


%     SetImageRotate(2);    
%     CheckWarning(ret);
    [ret,XPixels, YPixels]=GetDetector;  %   Get the CCD size
    CheckWarning(ret);
    
    %%% moved this stuff from initialize acquisition body %%%
%     if acq.limited
%         [ret] = SetAcquisitionMode(3);
%         CheckWarning(ret);
%         [ret] = SetNumberKinetics(acq.vid_len); % moved this down
%         CheckWarning(ret);
%     else
%         [ret] = SetAcquisitionMode(5);
%         CheckWarning(ret);            
%     end

    if acq.synthetic
        [real_exp,real_acc,real_cyc] = deal(acq.exposure_time, 0, acq.kinetic_cycle_time);
    else
        [ret,real_exp,real_acc,real_cyc] = GetAcquisitionTimings();
    end
    acq.cycle_time = real_cyc;
    acq.exposure_time = real_exp;


    if acq.synthetic
        acq.framerate = 24.9626;
    else
        acq.framerate = 1/real_cyc; 
    end
    
    handles.framerate.String = num2str(acq.framerate);
    

    default_limit = 1000000;
    if ~acq.limited
        vid_len = default_limit;
    else
        vid_duration = str2num(handles.duration_input.String);
        vid_len = round(vid_duration*acq.framerate);
    end

    real_total_time = vid_len/acq.framerate;
    handles.vid_len = vid_len;
    handles.vid_len_output.String = num2str(vid_len);
%     handles.total_time.String = num2str(real_total_time);
    handles.duration_output.String = sprintf('%g',real_total_time);

    handles.listener_switch.Value = 0;
    handles.listener.Enabled = 0;
    set(handles.slider_frames,'Value',1);
    set(handles.slider_frames,'Min',1,'Max',vid_len,'SliderStep',[1/(vid_len-1) 1/(vid_len-1)]);
    
    skip = str2num(handles.skip_frames.String);
    handles.slider_frames.SliderStep = (handles.slider_frames.SliderStep) * skip;

    acq.vid_len = vid_len;
    acq.duration = real_total_time;
    
    % this is in initialize acq body now
%     if acq.limited
%         [ret] = SetNumberKinetics(acq.vid_len);
%         CheckWarning(ret);
%     end

    handles.slider_frames.Value = 1;
    handles.slider_frames.Max = vid_len; 

    crop_position = handles.crop_ROI;
%     crop = handles.crop.Value;
    crop = 1;
    if crop
        end_Y = crop_position(1);
        start_Y = crop_position(1) + crop_position(3) - 1;
        end_X = crop_position(2);
        start_X = crop_position(2) + crop_position(4) - 1;

        end_Y = 512 - end_Y + 1;
        start_Y = 512 - start_Y + 1;
        end_X = 512 - end_X + 1;
        start_X = 512 - start_X + 1;
    end

    acq.len_x = (end_X - start_X + 1)/acq.binning;
    acq.len_y = (end_Y - start_Y + 1)/acq.binning;
    acq.vid_size = [acq.len_y,acq.len_x,vid_len];
    acq.dim_vid = acq.len_y;

    [ret]=SetImage(acq.binning,acq.binning,start_X,end_X,start_Y,end_Y); %   Set the image size
    CheckWarning(ret);


    curr_file_num = handles.current_file_num; % old file num
    if curr_file_num > 0
        handles = delete_all_display_objects(handles,curr_file_num);
    end
    initialize_ax_video(handles,acq.dim_vid);

%     set(handles.ax_video,'Xlim',[0.5 acq.len_x + 0.5],'Ylim',[0.5 acq.len_y+0.5]);
%     colormap(handles.ax_video,gray(256));
    
    if acq.spool
        % now after everything is ok, open files and stuff
        filename = handles.filename.String;
        acq.path = handles.pathname.String;

        
        switch handles.analysis_mode_setting
            case 'finding focus'
                extension = '_finding_focus_';
            case 'finding area'
                extension = '_finding_area_';
            otherwise
                extension = [];
        end

        time_str = clock_to_string();

        acq.spool_file_num = 1;
        acq.filename_spool_temp_no_ext = [acq.path '\' time_str '_' filename extension '_spool_temp'];
        acq.filename_spool_temp = [acq.path '\' time_str '_' filename extension '_spool_temp.tif'];

        acq.filename_resave = [acq.path '\' time_str '_' filename extension '.rdt'];
%         [acq.resave_tif_object,acq.tag_struct] = initialize_resave_file(acq.filename_resave,acq.len_x,acq.len_y);
        acq.resave_file_descriptor = fopen(acq.filename_resave, 'w+');

        acq.num_saved_acc = 0;

    else
        acq.spool = 0;
        SetSpool(0,7, '', 10);
    end

    time_interval_pause = handles.acquisition_settings.time_interval_pause;
    acq.interval_frames = round(time_interval_pause*acq.framerate);

    acq.current_sorting_val = handles.sort_type.Value;

    acq.abort = 0;

    acq.delay_col = [0 1 0];
    handles.delay.BackgroundColor = [0 1 0];
    










