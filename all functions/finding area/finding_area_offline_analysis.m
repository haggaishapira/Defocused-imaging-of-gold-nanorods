function analysis = finding_area_offline_analysis(handles,analysis_info,analysis)
    
    vid_len = analysis.vid_len;
    file_metadata = get_current_file_metadata(handles);

    wait_bar = waitbar(0,sprintf('frame %d/%d', 0, vid_len));
    for i=1:10:vid_len
        frame = get_frame(handles,i,0);
        single_frame_finding_area_core(handles,analysis_info,frame,handles.stage_settings,i);
        if ~mod(i,10)
            waitbar(i/vid_len,wait_bar,sprintf('frame %d/%d', i, vid_len), i, vid_len);
        end
        update_frame(handles,i);
        handles.slider_frames.Value = i;
        display_frame_and_time(handles,i,file_metadata.framerate);
        drawnow
    end
    waitbar(vid_len,wait_bar,sprintf('frame %d/%d', 0, vid_len), vid_len, vid_len);
    close(wait_bar);           










