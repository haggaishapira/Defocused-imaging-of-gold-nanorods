function add_frame_to_resave_file(file_descriptor,frame)

    t1 = toc;
    frame = imrotate(frame,90);
    frame = fliplr(frame);
%     frame = flipud(frame);
    
    fwrite(file_descriptor,frame,'uint16');

%     fprintf('resave frame time: %d\n', toc-t1);






