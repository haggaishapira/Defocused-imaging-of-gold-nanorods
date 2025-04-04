function frame = get_frame(handles,i,get_correction)

    acquisition = getappdata(0,'acquisition');
    extension = handles.extension;
    [file_metadata,~] = get_current_file_metadata(handles);

    switch extension
        case '.rdt'
            f_read = file_metadata.rdt_file_descriptor;
            dim_vid = file_metadata.dim_vid;
            offset = dim_vid*dim_vid*2*(i-1);
            fseek(f_read,offset,-1);
            frame = fread(f_read,dim_vid*dim_vid,'*uint16');
            frame = reshape(frame,[dim_vid,dim_vid]);
            frame = preprocess_frame(frame,0);
            1;
        case ''
            f_read = handles.f_read;
            offset = 512*512*2*(i-1);
            fseek(f_read,offset,-1);
            frame = fread(f_read,512*512,'uint16');
        case '.fits'
            if ~acquisition
%                 name = [handles.full_name '.fits'];
%                 file_num = handles.
%                 handles.file_list.Value = num_files;
%                 t1 = toc;
                frame = fitsread(file_metadata.full_name,'PixelRegion',{[1 512],[1 512],i});
                frame = imrotate(frame,-90);
                frame = flipud(frame);
%                 fprintf('get fits time: %d\n',toc-t1);

%                 frame = imrotate(frame,180);
            else
                f_read = handles.f_read;
                offset = handles.offset_fits + 512*512*2*(i-1);
                fseek(f_read,offset,-1);
                frame = fread(f_read,512*512,'uint16');
                try
                    frame = reshape(frame,[512 512]);
                    frame = frame - 2^15;  
                    frame = imrotate(frame,180);
                    if min(frame(:)) < 0
                        disp('bad');
                    end
                catch e
                    fprintf('failed at frame %d',i);
                    frame = zeros(512,512,'uint16');
                end
            end
        case '.tif'
            warning off MATLAB:tifflib:TIFFReadDirectory:libraryWarning;
            warning ('off','all');

%             ti = Tiff(handles.filename_read_tif, 'r');
            [file_metadata,~] = get_current_file_metadata(handles);
            ti = file_metadata.tif_object;
            setDirectory(ti,i);
            frame = ti.read();
            frame = preprocess_frame(frame,0);
        case '.BTF'
            warning off MATLAB:tifflib:TIFFReadDirectory:libraryWarning;
            warning ('off','all');

%             ti = Tiff(handles.filename_read_tif, 'r');
            [file_metadata,~] = get_current_file_metadata(handles);
            ti = file_metadata.tif_object;
            setDirectory(ti,i);
            frame = ti.read();
            frame = preprocess_frame(frame,0);

    end
%     frame = double(frame);

    % fourier correction
%     get_correction = 0;   
%     tic
    analysis = get_current_analysis(handles);
    if get_correction && ~analysis.empty
        corr_x = analysis.stage_correction_x(i);
        corr_y = analysis.stage_correction_y(i);
        if ~isempty(analysis.diff_phase)
            if corr_x ~= 0 || corr_y ~= 0
                diff_phase = analysis.diff_phase(i);
                frame = calculate_corrected_frame(frame,corr_x,corr_y,diff_phase);
%                 disp('corrected');
            end
        end
    end
%     toc







