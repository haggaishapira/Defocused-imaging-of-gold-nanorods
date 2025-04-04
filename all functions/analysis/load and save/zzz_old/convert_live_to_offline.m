
function convert_live_to_offline(filename_read,vid_size,num_mol,framerate,bits_per_pixel,binning,...
                            vid_duration,exposure_time,laser_power,gain)

vid_len = vid_size(3);
filename_write = [filename_read(1:end-3) 'rtr'];
   
f_read = fopen(filename_read,'r');

for i=1:14
    fgets(f_read);
end

molecules = [];

for i=1:num_mol
    molecule.t = zeros(vid_len,1,'double');
    molecule.ROI = zeros(4,vid_len,'int16');
    molecule.back = zeros(vid_len,1,'int16');
    molecule.int = zeros(vid_len,1,'int16');
    molecule.theta_half = zeros(vid_len,1,'int16');
    molecule.phi_half = zeros(vid_len,1,'int16');
    molecule.theta_whole = zeros(vid_len,1,'int16');
    molecule.phi_whole = zeros(vid_len,1,'int16');
    molecule.trace_theta_half = zeros(vid_len,1,'int16');
    molecule.trace_phi_half = zeros(vid_len,1,'int16');
    molecule.trace_theta_whole = zeros(vid_len,1,'int16');
    molecule.trace_phi_whole = zeros(vid_len,1,'int16');
    molecules = [molecules molecule];
end

wait_bar = waitbar(0,sprintf('frame %d/%d', 0,vid_len));

for i=1:vid_len
    for j=1:num_mol
        molecules(j).t(i) = fread(f_read,1,'double');
        molecules(j).ROI(:,i) = fread(f_read,4,'int16');
        molecules(j).back(i) = fread(f_read,1,'int16');
        molecules(j).int(i) = fread(f_read,1,'int16');
        molecules(j).theta_half(i) = fread(f_read,1,'int16');
        molecules(j).phi_half(i) = fread(f_read,1,'int16');
        molecules(j).theta_whole(i) = fread(f_read,1,'int16');
        molecules(j).phi_whole(i) = fread(f_read,1,'int16');
        molecules(j).trace_theta_half(i) = fread(f_read,1,'int16');
        molecules(j).trace_phi_half(i) = fread(f_read,1,'int16');
        molecules(j).trace_theta_whole(i) = fread(f_read,1,'int16');
        molecules(j).trace_phi_whole(i) = fread(f_read,1,'int16');
    end
    waitbar(i/vid_len,wait_bar,sprintf('frame %d/%d', i,vid_len));
end
close(wait_bar);

fclose(f_read);
    
% save_analysis_v3(filename_write,vid_len,framerate,molecules);
    
save_analysis_v3(filename_write,vid_size,framerate,molecules,bits_per_pixel,binning,...
                            vid_duration,exposure_time,laser_power,gain)
    
    
    
    
    