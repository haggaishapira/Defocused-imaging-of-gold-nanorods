function [total_num_mol,avg_closest_dist,total_int,all_positions,uncrowded_num_mol,uncrowded_positions] = ...
                        single_frame_immobilization_mode_core(frame,i,analysis_settings,analysis_info,analysis)

% function [total_num_mol,avg_closest_dist,total_int,all_positions,distance_matrix,ints,uncrowded_num_mol,uncrowded_positions] = ...
%                         single_frame_immobilization_mode_core(frame,i,analysis_settings,analysis_info,analysis)

    if ~mod(i-1,10)
%         [positions,num_mol,closest_molecule_distances] = find_positions_by_focus(analysis_settings,frame);
        [all_positions,ints,total_num_mol] = find_positions_when_focused(analysis_info,frame);
        [distance_matrix,min_distances] = calc_distances(all_positions);
        min_dist = analysis_info.min_distance_pixels;
        [uncrowded_positions,uncrowded_num_mol] = remove_crowded_positions...
                                                    (all_positions,distance_matrix,ints,min_dist);

%         avg_closest_dist = mean(closest_molecule_distances);
        avg_closest_dist = mean(min_distances);
        total_int = sum(frame(:));
    else
        % all
        total_num_mol = analysis.total_num_mol_trace(i-1);
        all_positions = analysis.all_positions_trace{i-1};
        avg_closest_dist = analysis.avg_closest_dist_trace(i-1);
%         ints = analysis.ints_trace(i-1);
%         distance_matrix = analysis.distance_matrix_trace{i-1};

        % uncrowded
        uncrowded_num_mol = analysis.uncrowded_num_mol_trace(i-1);
        uncrowded_positions = analysis.uncrowded_positions_trace{i-1};

        total_int = analysis.total_int(i-1);    
    end






