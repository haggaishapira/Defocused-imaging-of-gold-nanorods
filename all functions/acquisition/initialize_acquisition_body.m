function [handles,acq] = initialize_acquisition_body(handles,acq)
    
    % trigger here
    if acq.trigger_microfluidics
        response_ok = send_message_and_test_response(handles.microfluidics_connection,'1');
        if response_ok
            disp('triggered microfluidics');
        else
            msgbox('trigger error, not acquiring');
            return;
        end
    end
    
    % everything back here again, because of 10 first frames
    if acq.limited
        [ret] = SetAcquisitionMode(3);
        CheckWarning(ret);
        [ret] = SetNumberKinetics(acq.vid_len);
        CheckWarning(ret);
        SetSpool(1,7, acq.filename_spool_temp_no_ext, 10);
    else
        [ret] = SetAcquisitionMode(5);
        CheckWarning(ret); 
    end
    [ret] = StartAcquisition();                   
    CheckWarning(ret);
    tic
    
    if acq.spool && ~acq.synthetic  
        acq = wait_until_file_ready(acq);
    end
    
    setappdata(0,'acquisition',1);
    disp('starting acquisition body');   




