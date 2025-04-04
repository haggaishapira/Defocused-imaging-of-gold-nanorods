function handles = update_section(handles,requested_section)
    %assume video length is a multiple of the section size
    f = handles.file_id;
    data_offset = handles.data_offset;
    
    section_size = handles.section_size;

    current_section = handles.current_section; 
    
    dim_video = 512;
    
    remainder = handles.section_remainder;
    if ~remainder
        real_current_section = (ftell(f)-data_offset)/dim_video/dim_video/2/section_size - 1;
        frame = (ftell(f)-data_offset)/dim_video/dim_video/2;
    else
        frame = (ftell(f)-data_offset)/dim_video/dim_video/2;
        if ~mod(frame,handles.section_size)
            real_current_section = (ftell(f)-data_offset)/dim_video/dim_video/2/section_size - 1;
        else
            real_current_section = ((ftell(f)-data_offset)/dim_video/dim_video/2 - remainder) / section_size;
        end
    end
    
    if current_section ~= real_current_section
        disp('error');
        disp(current_section);
    end


    offset = data_offset + requested_section * section_size * dim_video * dim_video * 2;
    fseek(f, offset, -1);
    
    if ~remainder
        current_section_size = section_size;
    else
        if requested_section == handles.num_sections - 1
            current_section_size = remainder;
        else
            current_section_size = section_size;
        end
    end
    
    tic
    section_line = uint16(fread(f,dim_video*dim_video*current_section_size,'uint16'));

    handles.video_section = reshape(section_line,[dim_video dim_video current_section_size]);
    handles.current_section = requested_section;
    update_handles(handles.figure1, handles);
