function save_analysis_v2(filename,video_size,framerate,gain,molecules)

num_mol = size(molecules,2);
vid_len = video_size(3);

t = (1:vid_len)/framerate;

f = fopen(filename,'w');

% fprintf(f,'filename: %s\n',filename);
fprintf(f,'video size: [%d,%d,%d]\n',video_size(1),video_size(2),video_size(3));
fprintf(f,'framerate: %d hz\n',framerate);
fprintf(f,'gain: %d\n', gain);
fprintf(f,'number of molecules: %d\n', num_mol);
fprintf(f,'t is double, all other fields are int16. 15 fields total\n');
fprintf(f,'t ROI background intensity theta-half phi-half theta-whole phi-whole trace-theta half-trace phi-half trace-theta-whole trace-phi-whole\n\n');

% n = ftell(f)

% wait_bar = waitbar(0,sprintf('frame %d/%d', 0,vid_len));
wait_bar = waitbar(0,sprintf('molecule %d/%d', 0,num_mol));

% y = cell2mat({molecules.phi_half});


for j=1:num_mol
    fwrite(f,t,'double');
    ROI = molecules(j).ROI; 
    back = molecules(j).back; 
    int = molecules(j).int; 
    theta_half = molecules(j).theta_half; 
    phi_half = molecules(j).phi_half;
    theta_whole = molecules(j).theta_whole; 
    phi_whole = molecules(j).phi_whole;
    trace_theta_half = molecules(j).trace_theta_half; 
    trace_phi_half = molecules(j).trace_phi_half;
    trace_theta_whole = molecules(j).trace_theta_whole; 
    trace_phi_whole = molecules(j).trace_phi_whole;

    fwrite(f,ROI,'int16');
    fwrite(f,back,'int16');
    fwrite(f,int,'int16');
    fwrite(f,theta_half,'int16');
    fwrite(f,phi_half,'int16');
    fwrite(f,theta_whole,'int16');
    fwrite(f,phi_whole,'int16');
    fwrite(f,trace_theta_half,'int16');
    fwrite(f,trace_phi_half,'int16');
    fwrite(f,trace_theta_whole,'int16');
    fwrite(f,trace_phi_whole,'int16');
    
    waitbar(j/num_mol,wait_bar,sprintf('molecule %d/%d', j,num_mol));
end
%     if ~mod(j,100)
%         waitbar(i/vid_len,wait_bar,sprintf('frame %d/%d', i,vid_len));
%     end
% end
close(wait_bar);
fclose(f);

        
        
        
        
        
        
        
        
        