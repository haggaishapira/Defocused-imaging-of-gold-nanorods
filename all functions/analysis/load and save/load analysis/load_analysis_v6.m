function [molecules,num_mol,total_int,stage_corr_x,stage_corr_y,distances] = load_analysis_v6(filename)

    load(filename);
    
    molecules = file_struct.molecules;
    num_mol = size(molecules,2);
    try
        total_int = file_struct.total_int;
        stage_corr_x = file_struct.stage_correction_x;
        stage_corr_y = file_struct.stage_correction_y;
        distances = file_struct.distances;
    catch e
        t = molecules(1).t;
        len = length(t);
        total_int = zeros(len,1);
        stage_corr_x = zeros(len,1);
        stage_corr_y = zeros(len,1);
        distances = [];
    end





