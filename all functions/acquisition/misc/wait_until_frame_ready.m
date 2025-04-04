function ready = wait_until_frame_ready(acq)
    ready = 0;
    warning off MATLAB:tifflib:TIFFReadDirectory:libraryWarning;    
    warning('off','all');


    % wait until image is fully saved
%         fseek(handles.f_read,0,1);
    f_read = acq.file_descriptor_tif;
    fseek(f_read,0,1);
%     len = ftell(f_read);
%     offset_tif = 2 * 641;
%     data_len = len - offset_tif;
%     frame_size_tif = (acq.dim_vid*acq.dim_vid+637);
%     num_saved_local = data_len/frame_size_tif/2;
    
    offset = ftell(f_read);
    num_saved_local = tif_offset_to_frame(acq,offset);

    num_saved_total = acq.num_saved_acc + num_saved_local;

    
    [ret, spool_progress] = GetSpoolProgress();
    
    while spool_progress < acq.i_total + 1 && num_saved_total < acq.i_total + 1
        [ret, spool_progress] = GetSpoolProgress();
        fseek(f_read,0,1);
%         offset_tif = 2 * 641;
%         data_len = len - offset_tif;
%         frame_size_tif = (acq.dim_vid*acq.dim_vid+637);
%         num_saved_local = data_len/frame_size_tif/2;

        offset = ftell(f_read);
        num_saved_local = tif_offset_to_frame(acq,offset);

        num_saved_total = acq.num_saved_acc + num_saved_local;
        pause(acq.kinetic_cycle_time/16);
        if acq.i_total == acq.vid_len
            pause(acq.kinetic_cycle_time*2);
            break;
        end
    end


