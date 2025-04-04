function save_analysis_v6(filename,vid_size,framerate,molecules,total_int,binning, stage_corr_x, stage_corr_y, distances)

num_mol = size(molecules,2);
file_struct.filename = filename;
file_struct.vid_size = vid_size;
file_struct.binning = binning;
file_struct.framerate = framerate;
file_struct.num_mol = num_mol;
file_struct.total_int = total_int;
file_struct.stage_correction_x = stage_corr_x;
file_struct.stage_correction_y = stage_corr_y;
file_struct.distances = distances;

file_struct.molecules = molecules;

% save_str = [filename '.mat'];
save([filename '.mat'],'file_struct','-mat');


        
        
        
        
        
        
        
        