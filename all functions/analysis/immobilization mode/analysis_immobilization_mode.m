function analysis = analysis_immobilization_mode(handles,analysis_settings,analysis_info,analysis)
    
    vid_len = analysis.vid_len;

    wait_bar = waitbar(0,sprintf('frame %d/%d', 0,vid_len));
    for i=1:vid_len
        frame = get_frame(handles,i);
        [total_num_mol,avg_closest_dist,total_int,all_positions,uncrowded_num_mol,uncrowded_positions] = ...
                                single_frame_immobilization_mode_core(frame,i,analysis_settings,analysis_info,analysis);
%         [total_num_mol,avg_closest_dist,total_int,all_positions,distance_matrix,ints,uncrowded_num_mol,uncrowded_positions] = ...
%                                 single_frame_immobilization_mode_core(frame,i,analysis_settings,analysis_info,analysis);


        % all mol
        analysis.total_num_mol_trace(i) = total_num_mol;
        analysis.all_positions_trace{i} = all_positions;
        analysis.avg_closest_dist_trace(i) = avg_closest_dist; % of all mol
%         analysis.distance_matrix_trace{i} = distance_matrix;   % of all mol
%         analysis.ints_trace{i} = ints;                         % of all mol

        % uncrowded
        analysis.uncrowded_num_mol_trace(i) = uncrowded_num_mol;
        analysis.uncrowded_positions_trace{i} = uncrowded_positions;
        
        % general
        analysis.total_int(i) = total_int;
        
        if ~mod(i,100)
            waitbar(i/vid_len,wait_bar,sprintf('frame %d/%d', i,vid_len));
        end
    end
    close(wait_bar);           



