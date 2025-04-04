function handles = register_area(handles,print)

    file_metadata = get_current_file_metadata(handles);
    vid_len = file_metadata.vid_len;

%     frame_num = 1;
    frame_num = vid_len;

    frame = get_frame(handles,frame_num,0);

    analysis_settings = handles.analysis_settings;
    center_x = analysis_settings.center_x_definition;
    center_y = analysis_settings.center_y_definition;
    ref_ROI_rad = round(analysis_settings.ref_ROI_dim / 2);

    area_ROI = [center_x-ref_ROI_rad center_y-ref_ROI_rad ref_ROI_rad*2+1 ref_ROI_rad*2+1];
    area_ROI_image = get_integer_pixel_ROI_image(frame,area_ROI);
    
    handles.area_reference = area_ROI_image;

    if print
        msgbox('registered area');
    end