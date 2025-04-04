function acq = wait_until_file_ready(acq)

    ready = 0;
    warning('off','all');
    while ~ready
        try
%             disp(acq.filename_spool_temp);
            im = imread(acq.filename_spool_temp);
            ready = 1;
        catch e
            continue;
        end
    end
    acq.file_descriptor_tif = fopen(acq.filename_spool_temp,'r');    
