function [video_size,framerate,gain,molecules] = load_live_analysis(filename_read,filename_write)

f = fopen(filename,'r');
% fgets(fileID);
% fscanf(fileID,'filename: %s\n');
video_size = fscanf(f,'video size: [%d,%d,%d]\n');
len = video_size(3);
framerate = fscanf(f,'framerate: %d hz\n');
gain = fscanf(f,'gain: %d\n');
num_mol = fscanf(f,'number of molecules: %d\n');
% preferred_analysis = fscanf(fileID,'preferred analysis: %s\n\n');
fgets(f);
fgets(f);
fgets(f);
molecules = [];

for i=1:num_mol
    molecule.t = zeros(vid_len,1,'double');
    molecule.ROI = zeros(4,len,'uint16');
    molecule.back = zeros(vid_len,1,'uint16');
    molecule.int = zeros(vid_len,1,'uint16');
    molecule.theta_half = zeros(vid_len,1,'uint16');
    molecule.phi_half = zeros(vid_len,1,'uint16');
    molecule.theta_whole = zeros(vid_len,1,'uint16');
    molecule.phi_whole = zeros(vid_len,1,'uint16');
    molecule.trace_theta_half = zeros(vid_len,1,'uint16');
    molecule.trace_phi_half = zeros(vid_len,1,'uint16');
    molecule.trace_theta_whole = zeros(vid_len,1,'uint16');
    molecule.trace_phi_whole = zeros(vid_len,1,'uint16');
    molecules = [molecules molecule];
    fscanf(f,'\n');
end

wait_bar = waitbar(0,sprintf('molecule %d/%d', 0,num_mol));

for i=1:vid_len
    for j=1:num_mol
        molecules(j).t(i) = fread(f,vid_len,'double');
        molecules(j).molecule.ROI(i) = reshape(ROI_flat,[4,vid_len]);
        molecules(j).molecule.back(i) = fread(f,vid_len,'int16');
        molecules(j).molecule.int(i) = fread(f,vid_len,'int16');
        molecules(j).molecule.theta_half(i) = fread(f,vid_len,'int16');
        molecules(j).molecule.phi_half(i) = fread(f,vid_len,'int16');
        molecules(j).molecule.theta_whole(i) = fread(f,vid_len,'int16');
        molecules(j).molecule.phi_whole(i) = fread(f,vid_len,'int16');
        molecules(j).molecule.trace_theta_half(i) = fread(f,vid_len,'int16');
        molecules(j).molecule.trace_phi_half(i) = fread(f,vid_len,'int16');
        molecules(j).molecule.trace_theta_whole(i) = fread(f,vid_len,'int16');
        molecules(j).molecule.trace_phi_whole(i) = fread(f,vid_len,'int16');
        molecules = [molecules molecule];
        fscanf(f,'\n');
    end
    waitbar(i/num_mol,wait_bar,sprintf('molecule %d/%d', i,num_mol));
end
close(wait_bar);

fclose(f);




