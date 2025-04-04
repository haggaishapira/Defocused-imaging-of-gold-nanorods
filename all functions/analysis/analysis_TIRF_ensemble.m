function analysis = analysis_TIRF_ensemble(handles,analysis_settings,analysis_info,analysis)
    
    dim_vid = analysis_info.dim_vid;
    vid_len = analysis.vid_len;

    for i=1:vid_len
        frame = get_frame(handles,i,0);
        [int_green,int_red,FRET] = single_frame_TIRF_ensemble_mode_core(analysis_info,analysis,frame);

        analysis.trace_green(i) = int_green;
        analysis.trace_red(i) = int_red;
        analysis.FRET_trace(i) = FRET;

    end





