function save_analysis(filename,video_size,framerate,gain,molecules)

num_mol = size(molecules,2);
vid_len = video_size(3);


fileID = fopen(filename,'w');
fprintf(fileID,'filename: %s\n',filename);
fprintf(fileID,'video size: [%d,%d,%d]\n',video_size(1),video_size(2),video_size(3));
fprintf(fileID,'framerate: %d hz\n',framerate);
fprintf(fileID,'gain: %d\n', gain);
fprintf(fileID,'number of molecules: %d\n\n', num_mol);

wait_bar = waitbar(0,sprintf('molecule %d/%d', 0,num_mol));
for i=1:num_mol
    fprintf(fileID,'molecule %d\n', i);
    focus = molecules(i).focus;
    fprintf(fileID,'focus\t%f\n', focus);
    fprintf(fileID,'frame\tROI\t\t\t\tbackground\tintensity\ttheta_half\tphi_half\ttheta_whole\tphi_whole\ttrace_theta_half\ttrace_phi_half\ttrace_theta_whole\ttrace_phi_whole\n');
    for j=1:vid_len
        ROI = molecules(i).ROI(:,j); 
        back = molecules(i).back(j); 
        int = molecules(i).int(j); 
        theta_half = molecules(i).theta_half(j); 
        phi_half = molecules(i).phi_half(j);
        theta_whole = molecules(i).theta_whole(j); 
        phi_whole = molecules(i).phi_whole(j);
        trace_theta_half = molecules(i).trace_theta_half(j); 
        trace_phi_half = molecules(i).trace_phi_half(j);
        trace_theta_whole = molecules(i).trace_theta_whole(j); 
        trace_phi_whole = molecules(i).trace_phi_whole(j);
        fprintf(fileID,'%d\t%d\t%d\t%d\t%d\t%.2f\t%.2f\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n',j,ROI,...
                back, int,...
                theta_half,phi_half,theta_whole,phi_whole,...
                trace_theta_half,trace_phi_half,trace_theta_whole,trace_phi_whole);
    end
    fprintf(fileID,'\n');
    waitbar(i/num_mol,wait_bar,sprintf('molecule %d/%d', i,num_mol));
end
close(wait_bar);
fclose(fileID);

        
        
        
        
        
        
        
        
        