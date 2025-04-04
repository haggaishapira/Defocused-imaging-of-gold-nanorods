function display_frame_and_time(handles,current_frame,framerate)
    
    t = current_frame/framerate;
    handles.output_frames.String = sprintf('%d',current_frame);
    handles.output_time.String = sprintf('%.2f',t);
