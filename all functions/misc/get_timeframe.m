function [first_frame,last_frame,first_t,last_t] = get_timeframe(handles,analysis)

    first_t = str2num(handles.first_t.String);
    last_t = str2num(handles.last_t.String);

    framerate = analysis.framerate;
    first_frame = max(1,round(first_t*framerate));
    last_frame = min(analysis.vid_len,round(last_t*framerate));

