function first_frames = acquire_first_frames_from_camera(handles, analysis_settings, acq, use_pre_acquired)

    len_x = acq.len_x;
    len_y = acq.len_y;
    num_first_frames = analysis_settings.num_first_frames;
%     num_first_frames = 10;

    % disable spool for live analysis acquisition
    SetSpool(0,7, '', 10);

    [ret] = SetAcquisitionMode(3);
    CheckWarning(ret);
    [ret] = SetNumberKinetics(num_first_frames);
    CheckWarning(ret);
    first_frames = zeros(len_y,len_x,num_first_frames); 
    [ret] = StartAcquisition();                   
    CheckWarning(ret);
    setappdata(0,'acquisition',1);


    if acq.synthetic && use_pre_acquired
        [pathname, filename, extension] = fileparts(acq.path_synthetic);
        first_frames_filename = [pathname '\' filename '_first_frames' '.mat'];
        if isfile(first_frames_filename)
            load(first_frames_filename);
%             handles.files(file_num).first_frames = first_frames;
            return;
        else
            use_pre_acquired = 0;
        end
    end

    
    if acq.synthetic && ~use_pre_acquired
%         path = acq.path_synthetic;
%         ti = Tiff(path, 'r');  
        ti = acq.tif_object;
        i = 1;
        for i=1:num_first_frames
            setDirectory(ti,i);
            frame = ti.read();
            frame = imrotate(frame,-90);
            frame = flipud(frame);
            first_frames(:,:,i) = frame;
        end
    else
        i = 1;
        while i <= num_first_frames
            if ~getappdata(0,'acquisition')
                abort_acquisition(1);
                return;
            end
            [ret, imageData, validfirst, validlast] = GetImages16(i,i,acq.dim_vid*acq.dim_vid);            
            if ret == atmcd.DRV_SUCCESS % data returned
                frame = reshape(imageData,len_y,len_x);
                frame = imrotate(frame,90);
                show_frame(handles,frame);
                pause(0.00001);
                first_frames(:,:,i) = frame;
                i = i+1;
            end
        end
    end

    setappdata(0,'acquisition',0);
    pause(0.00001);






