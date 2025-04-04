function first_frames = get_first_frames(handles,live_analysis,use_pre_acquired,dim_vid)       
    

    num_first_frames = min(handles.analysis_settings.num_first_frames,handles.vid_len);
    
    if live_analysis
        first_frames = acquire_first_frames_from_camera(handles,handles.acq, use_pre_acquired);
    else
        file_metadata = handles.file_metadatas(handles.current_file_num);
        if ~isempty(file_metadata.first_frames) && use_pre_acquired
            first_frames = file_metadata.first_frames;
        else
            first_frames = zeros(dim_vid,dim_vid,num_first_frames,'uint16');
            for i=1:num_first_frames
                frame = get_frame(handles,i,0);  
                first_frames(:,:,i) = frame;
            end
        end
    end