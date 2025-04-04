function save_analysis_v4(filename,vid_size,framerate,molecules,bits_per_pixel,binning,...
                            vid_duration,exposure_time,laser_power,gain)

num_mol = size(molecules,2);
vid_len = vid_size(3);
t = (1:vid_len)/framerate;

f_write = fopen(filename,'w');

fprintf(f_write,'file path and name: %s\n',filename);
fprintf(f_write,'video size (y,x,len): [%d,%d,%d]\n',vid_size(1),vid_size(2),vid_len);
fprintf(f_write,'bits per pixel: %d\n', 16);
fprintf(f_write,'binning: %d\n', 1);
fprintf(f_write,'duration (sec): %f\n',vid_duration);
fprintf(f_write,'framerate (1/sec): %f\n',framerate);
fprintf(f_write,'exposure time (sec): %f\n',exposure_time);
fprintf(f_write,'laser power (uW): %d\n', laser_power);
fprintf(f_write,'gain: %d\n\n', gain);
fprintf(f_write,'number of molecules: %d\n', num_mol);
fprintf(f_write,'t is double (64bit), all other fields are int16 (signed int). 15 fields total\n');
fprintf(f_write,'t ROI background intensity theta-half phi-half theta-whole phi-whole trace-theta half-trace phi-half trace-theta-whole trace-phi-whole\n\n');

wait_bar = waitbar(0,sprintf('molecule %d/%d', 0,num_mol));

for j=1:num_mol
    fwrite(f_write,t,'double');
    ROI = molecules(j).ROI; 
    back = molecules(j).back; 
    int = molecules(j).int; 
    back = int32(back);
    int = int32(int);
    
    theta_half = molecules(j).theta_half; 
    phi_half = molecules(j).phi_half;
    theta_whole = molecules(j).theta_whole; 
    phi_whole = molecules(j).phi_whole;
    trace_theta_half = molecules(j).trace_theta_half; 
    trace_phi_half = molecules(j).trace_phi_half;
    trace_theta_whole = molecules(j).trace_theta_whole; 
    trace_phi_whole = molecules(j).trace_phi_whole;

    fwrite(f_write,ROI,'int16');
    fwrite(f_write,back,'int32');
    fwrite(f_write,int,'int32');
    fwrite(f_write,theta_half,'int16');
    fwrite(f_write,phi_half,'int16');
    fwrite(f_write,theta_whole,'int16');
    fwrite(f_write,phi_whole,'int16');
    fwrite(f_write,trace_theta_half,'int16');
    fwrite(f_write,trace_phi_half,'int16');
    fwrite(f_write,trace_theta_whole,'int16');
    fwrite(f_write,trace_phi_whole,'int16');
    
    waitbar(j/num_mol,wait_bar,sprintf('molecule %d/%d', j,num_mol));
end
close(wait_bar);

fclose(f_write);

        
        
        
        
        
        
        
        
        