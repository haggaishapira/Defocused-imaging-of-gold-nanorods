function [handles,file_metadata,error] = initialize_file(handles,full_name,empty_file_metadata)
    
    file_metadata = empty_file_metadata;
    [pathname, filename, extension] = fileparts(full_name);
    file_metadata.full_name = full_name;

    error = 0;
    switch extension
        case '.rdt'
            file_metadata = load_file_metadata(file_metadata); % try to fill in existing fields, dont get extra
            file_metadata.full_name = full_name; % override with real full name
            file_metadata.pathname = pathname; % override with real path name
            f_read = fopen(file_metadata.full_name,'r');
%             fseek(f_read,0,1);
%             vid_len = ftell(f_read)/512/512/2;
%             empty_file_metadata.vid_len = vid_len;
%             empty_file_metadata.size(3) = vid_len;
            file_metadata.rdt_file_descriptor = f_read;
        case ''
            % old binary version
            fseek(f_read,0,1);
            vid_len = ftell(f_read)/512/512/2;
            fseek(f_read,0,-1);
            file_metadata.vid_size = [512 512 vid_len];            
            handles.data_offset = 0;
            section_size = 1;
            section_size = min(vid_len, section_size);
            handles.section_size = section_size;
            remainder = mod(vid_len,section_size);
            handles.section_remainder = remainder;
            if ~remainder 
                handles.num_sections = vid_len/section_size;
            else
                handles.num_sections = (vid_len + section_size - remainder) / section_size;
            end
            section_line = uint16(fread(f_read,dim_video*dim_video*section_size,'uint16'));
            handles.video_section = reshape(section_line,[dim_video dim_video section_size]);
            handles.current_section = 0;   
        case '.fits'
            handles.filename_fits = full_name;
            fits_info = fitsinfo(full_name);
            handles.fits_info = fits_info;
            handles.offset_fits = fits_info.PrimaryData.Offset - 1;
            file_metadata.vid_size = fits_info.PrimaryData.Size;
            keyword_cell = fits_info.PrimaryData.Keywords;
            cycle_time = get_field_data(keyword_cell,'KCT');
            file_metadata.framerate = 1/cycle_time;
            file_metadata.binning = get_field_data(keyword_cell,'HBIN');
        case '.tif'
%             file.filename_read_tif = full_name;
            file_metadata.full_name = full_name;
            warning off MATLAB:tifflib:TIFFReadDirectory:libraryWarning;    
            warning('off','all');            
            file_metadata.tif_object = Tiff(full_name, 'r');
            info = imfinfo(full_name);
            vid_len = size(info,1);
            width = info(1).Width;
            length = info(1).Height;
            file_metadata.vid_size = [length width vid_len];
%             file_metadata.vid_size = [512 512 vid_len];
%             file.framerate = 1/0.1156;
%             cycle_time = info(1).UnknownTags(4).Value;
%             cycle_time = 0.1156;
            cycle_time = 0.001;
            if cycle_time == 0
                file_metadata.framerate = 24.9626;
            else
                file_metadata.framerate = 1/cycle_time;
            end
        case '.BTF'
%             file.filename_read_tif = full_name;
            empty_file_metadata.full_name = full_name;
            warning off MATLAB:tifflib:TIFFReadDirectory:libraryWarning;    
            warning('off','all');            
            empty_file_metadata.tif_object = Tiff(full_name, 'r');
            info = imfinfo(full_name);
            vid_len = size(info,1);
            width = info(1).Width;
            length = info(1).Height;
            empty_file_metadata.vid_size = [length width vid_len];
%             file.framerate = 1/0.1156;
            try
                cycle_time = info(1).UnknownTags(4).Value;
            catch e
                cycle_time = 0.002;
            end
            if cycle_time == 0
                empty_file_metadata.framerate = 24.9626;
            else
                empty_file_metadata.framerate = 1/cycle_time;
            end 
        otherwise
            error = 1;
            return;
    end

    file_metadata.vid_len = file_metadata.vid_size(3);
    file_metadata.duration = file_metadata.vid_len/file_metadata.framerate;     







    

