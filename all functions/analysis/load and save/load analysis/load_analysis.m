function [video_size,framerate,gain,molecules] = load_analysis(filename)

fileID = fopen(filename,'r');
fgets(fileID);
% fscanf(fileID,'filename: %s\n');
video_size = fscanf(fileID,'video size: [%d,%d,%d]\n');
vid_len = video_size(3);
framerate = fscanf(fileID,'framerate: %d hz\n');
gain = fscanf(fileID,'gain: %d\n');
num_mol = fscanf(fileID,'number of molecules: %d\n\n');
% preferred_analysis = fscanf(fileID,'preferred analysis: %s\n\n');

molecules = [];
wait_bar = waitbar(0,sprintf('molecule %d/%d', 0,num_mol));

for i=1:num_mol
    fscanf(fileID,'molecule %d\n');
%     molecule.ROI = fscanf(fileID,'ROI: [%d,%d,%d,%d]\n');
    fscanf(fileID,'focus\t%f');
    fgets(fileID);
    fscanf(fileID,'frame\tROI\t\t\t\tbackground\tintensity\ttheta_half\tphi_half\ttheta_whole\tphi_whole\ttrace_theta_half\ttrace_phi_half\ttrace_theta_whole\ttrace_phi_whole\n');
    ROI = zeros(4,vid_len);
    back = zeros(1,vid_len);
    int = zeros(1,vid_len);
    theta_half = zeros(1,vid_len);
    phi_half = zeros(1,vid_len);
    theta_whole = zeros(1,vid_len);
    phi_whole = zeros(1,vid_len);
    trace_theta_half = zeros(1,vid_len);
    trace_phi_half = zeros(1,vid_len);
    trace_theta_whole = zeros(1,vid_len);
    trace_phi_whole = zeros(1,vid_len);
    for j=1:vid_len
        s = fgets(fileID);
        a = sscanf(s,'%f');
        ROI(:,j) = a(2:5);
        back(:,j) = a(6);
        int(:,j) = a(7);
        theta_half(j) = a(8);
        phi_half(j) = a(9);
        theta_whole(j) = a(10);
        phi_whole(j) = a(11);
        trace_theta_half(j) = a(12);
        trace_phi_half(j) = a(13);
        trace_theta_whole(j) = a(14);
        trace_phi_whole(j) = a(15);
    end
    molecule.ROI = ROI;
    molecule.back = back;
    molecule.int = int;
    molecule.theta_half = theta_half;
    molecule.phi_half = phi_half;
    molecule.theta_whole = theta_whole;
    molecule.phi_whole = phi_whole;
    molecule.trace_theta_half = trace_theta_half;
    molecule.trace_phi_half = trace_phi_half;
    molecule.trace_theta_whole = trace_theta_whole;
    molecule.trace_phi_whole = trace_phi_whole;
    molecule.ROI_handle = [];
    molecules = [molecules molecule];
    fscanf(fileID,'\n');
    waitbar(i/num_mol,wait_bar,sprintf('molecule %d/%d', i,num_mol));
end
fclose(fileID);
close(wait_bar);




