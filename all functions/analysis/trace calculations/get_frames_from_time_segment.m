function segment = get_frames_from_time_segment(trace,start_time,end_time,framerate)
    
    first_frame = round(start_time*framerate);
    first_frame = max(first_frame,1);

    len = length(trace);
    last_frame = round(end_time*framerate);
    last_frame = min(last_frame,len);
    
    segment = trace(first_frame:last_frame);


