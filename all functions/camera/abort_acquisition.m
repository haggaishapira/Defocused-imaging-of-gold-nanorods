function abort_acquisition(warning)
    setappdata(0,'acquisition',0);
    disp('aborting acquisition');
    [ret]=AbortAcquisition;
    if warning
        CheckWarning(ret);
    end
