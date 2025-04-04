function acq = update_spool_reading_file(acq)

    acq.i_local = 1;
    acq.spool_file_num = acq.spool_file_num + 1;

    binning = acq.binning;
    
    
    switch binning
        case 1
            factor = 512/acq.dim_vid;
            num_frames_in_file = 4085*(factor^2);
        case 2
            factor = 256/acq.dim_vid;
            num_frames_in_file = 16288*(factor^2);
    end
    
    acq.num_saved_acc = (acq.spool_file_num-1) * num_frames_in_file;
    acq.filename_spool_temp = [acq.filename_spool_temp_no_ext sprintf('_X%d.tif',acq.spool_file_num)];
%     fclose(acq.file_descriptor_tif);

    % delete file from disk!
%     delete(acq.file_descriptor_tif);
    delete(acq.filename_spool_temp);


    acq = wait_until_file_ready(acq);

    fprintf('switched to next spool file after %d frames.',num_frames_in_file);





    