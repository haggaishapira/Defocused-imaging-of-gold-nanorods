function frame = preprocess_frame(frame,live,acq)
% 
%     frame = imrotate(frame,-90);

    if live
        frame = double(frame);
        
        % scattering
        frame = flipud(frame);
        frame = fliplr(frame);
%         frame = rot90(frame);

        % TIRF
%         frame = rot90(frame);
    else
%         frame = flipud(frame);
        % scattering
        frame = imrotate(frame,90);
        frame = fliplr(frame);
        frame = double(frame);

        % TIRF samrat
%         frame = imrotate(frame,90);
%         frame = fliplr(frame);
%         frame = double(frame);


    end