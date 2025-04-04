function frame = convert_frame_to_save_format(frame)
    frame = min(frame,8000);
    frame = max(frame,100); 
    frame = double(frame);
    frame = frame/3000;
    frame = frame*255;
    frame = uint8(frame);
