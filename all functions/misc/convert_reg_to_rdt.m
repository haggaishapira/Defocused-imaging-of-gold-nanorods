


default_path = [handles.pathname.String '/*.*'];
[filename,pathname] = uigetfile(default_path, 'select video file');
full_name_read = [pathname,filename];
f_read = fopen(full_name_read,'r');

full_name_write = [full_name_read 'rdt'];
f_write = fopen(filename_write,'w');

fprintf(f_write,'file path and name: %s\n',filename_write);
fprintf(f_write,'video size (y,x,len): [%d,%d,%d]\n',len_y,len_x,vid_len);
fprintf(f_write,'bits per pixel: %d\n', bits_per_pixel);
fprintf(f_write,'binning: %d\n', binning);
fprintf(f_write,'duration (sec): %d\n',vid_duration);
fprintf(f_write,'framerate (1/sec): %f\n',5);
fprintf(f_write,'exposure time (sec): %f\n',0.003);
fprintf(f_write,'laser power (uW): %d\n', laser_power);
fprintf(f_write,'gain: %d\n\n', gain);