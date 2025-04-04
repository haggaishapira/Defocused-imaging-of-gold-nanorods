function offset = tif_frame_to_offset(acq,i)
    
    dim_vid = acq.dim_vid;
    binning = acq.binning;

    switch dim_vid
        case 64
            val = 189;
        case 256
            if binning == 1
                val = 189;
            else
                val = 381;
            end
        case 512
            val = 637;
    end

    offset = 2 * (4 + val + (i-1) * (dim_vid * dim_vid + val));