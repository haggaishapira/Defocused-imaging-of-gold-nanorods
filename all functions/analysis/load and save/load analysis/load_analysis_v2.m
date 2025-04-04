function [video_size,framerate,gain,molecules] = load_analysis_v2(filename)

f = fopen(filename,'r');
% fgets(fileID);
% fscanf(fileID,'filename: %s\n');
video_size = fscanf(f,'video size: [%d,%d,%d]\n');
vid_len = video_size(3);
framerate = fscanf(f,'framerate: %d hz\n');
gain = fscanf(f,'gain: %d\n');
num_mol = fscanf(f,'number of molecules: %d\n');
% preferred_analysis = fscanf(fileID,'preferred analysis: %s\n\n');
fgets(f);
fgets(f);
fgets(f);
molecules = [];
wait_bar = waitbar(0,sprintf('molecule %d/%d', 0,num_mol));

for i=1:num_mol
    molecule.t = fread(f,vid_len,'double');
    ROI_flat = fread(f,4*vid_len,'int16');
    molecule.ROI = reshape(ROI_flat,[4,vid_len]);
    molecule.back = fread(f,vid_len,'int16');
    molecule.int = fread(f,vid_len,'int16');
    molecule.theta_half = fread(f,vid_len,'int16');
    molecule.phi_half = fread(f,vid_len,'int16');
    molecule.theta_whole = fread(f,vid_len,'int16');
    molecule.phi_whole = fread(f,vid_len,'int16');
    molecule.trace_theta_half = fread(f,vid_len,'int16');
    molecule.trace_phi_half = fread(f,vid_len,'int16');
    molecule.trace_theta_whole = fread(f,vid_len,'int16');
    molecule.trace_phi_whole = fread(f,vid_len,'int16');
    molecule.ROI_handle = [];
    molecules = [molecules molecule];
    fscanf(f,'\n');
    waitbar(i/num_mol,wait_bar,sprintf('molecule %d/%d', i,num_mol));
end
fclose(f);
close(wait_bar);




