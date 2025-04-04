function [int_green,int_red,FRET] = single_frame_TIRF_ensemble_mode_core(analysis_info,analysis,frame)
   
    dim_vid = analysis_info.dim_vid;
    green = frame(:,1:dim_vid/2);
    red = frame(:,dim_vid/2+1:end);
    
    int_green = sum(green(:));
    int_red = sum(red(:));

    if analysis_info.subtract_background
        int_green = int_green - analysis.TIRF_background_green;
        int_red = int_red - analysis.TIRF_background_red;
    end

    FRET = int_red/(int_green+int_red);