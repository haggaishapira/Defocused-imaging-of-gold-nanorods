function [frame,bad] = get_frame_live(handles,acq,i)
    
    if acq.synthetic
        path = acq.path_synthetic;
        warning off MATLAB:tifflib:TIFFReadDirectory:libraryWarning;    
        warning('off','all');
%         ti = Tiff(path, 'r');
        ti = acq.tif_object;
        setDirectory(ti,i);
        frame = ti.read();
        frame = double(frame);

        % scattering
        frame = imrotate(frame,-90);
        frame = flipud(frame);
        
        % TIRF
%         frame = imrotate(frame,-90);
%         frame = flipud(frame);

        success = 1;
        handles.frame = frame;
        show_frame(handles,frame);
        return;
    end

%     fprintf('trying to get frame %d\n',i);
    %% get image    
    if acq.spool
        wait_until_frame_ready(acq);

        f_read = acq.file_descriptor_tif;

        offset = tif_frame_to_offset(acq,i);
        fseek(f_read,offset,-1);
        frame = fread(f_read,acq.dim_vid*acq.dim_vid,'*uint16');

        if size(frame,1) * size(frame,2) ~= acq.dim_vid * acq.dim_vid
            frame = randi(1000,acq.dim_vid,acq.dim_vid);
            bad = 1;
        else
            bad = 0;
        end

        frame = reshape(frame,[acq.dim_vid acq.dim_vid]);
        frame = preprocess_frame(frame,1);

    else
        bad = 0;
        success = 0;
        while ~success
            [ret, arr, validfirst, validlast] = GetImages16(double(i),double(i), acq.dim_vid*acq.dim_vid);
            if ret ~= atmcd.DRV_SUCCESS
                pause(acq.cycle_time/16);
            else
                success = 1;
            end
%             frame = zeros(acq.dim_vid,acq.dim_vid);
%             success = 0;
%             return;
        end
        
        frame = reshape(arr,[acq.dim_vid acq.dim_vid]);

        % scattering
        frame = imrotate(frame,90);

        % TIRF - empty

    end

%     handles.background_frame = frame;
%     sub =  frame - handles.background_frame;
%     frame = sub;
%     frame(frame<0) = 0;
    show_frame(handles,frame);


      
