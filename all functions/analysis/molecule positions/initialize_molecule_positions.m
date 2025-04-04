function analysis = initialize_molecule_positions(analysis_settings,analysis_info,analysis)

    avg_frame = analysis_info.avg_frame;
    search_method = analysis_info.get_positions_method;
    switch search_method
        case 'search when focused'
            [all_positions,ints,total_num_mol] = find_positions_when_focused(analysis_settings,analysis_info,avg_frame);    
             [distance_matrix,analysis.distances] = calc_distances(all_positions);            
            min_dist = analysis_info.min_distance_pixels;
            [uncrowded_positions,uncrowded_num_mol] = remove_crowded_positions...
                                                            (all_positions,distance_matrix,ints,min_dist);
            num_mol = uncrowded_num_mol;
            positions = uncrowded_positions;
            defocus_inds = ones(num_mol,1);
            theta_inds = 7*ones(num_mol,1);
            phi_inds = ones(num_mol,1);
        case 'search when defocused - preset defocus'
            frame1 = avg_frame; % change this later
            [positions,num_mol,defocus_inds,theta_inds,phi_inds] = find_positions_common_defocus(analysis_settings,analysis_info,frame1,avg_frame);
        case 'search when defocused - find common defocus'
%             defocus_ind = find_defocus();
            [positions,num_mol] = find_positions_common_defocus(analysis_info,avg_frame);
        case 'search when defocused - find defocus per molecule'
            [analysis_info,ROIs,lst_sqs,defocuses] = find_ROIs_uncommon_defocus(handles); 
        case 'registered positions'
            positions = analysis_info.registered_positions;

%             if hand

            num_mol = size(positions,1);
            defocus_inds = 8*ones(num_mol,1);
            theta_inds = 7*ones(num_mol,1);
            phi_inds = ones(num_mol,1);
        case 'select positions manually'
            [x,y] = getpts(analysis_info.ax_video);
            positions = round([x y]);
            num_mol = size(positions,1);
            defocus_inds = 12*ones(num_mol,1);
            theta_inds = 7*ones(num_mol,1);
            phi_inds = ones(num_mol,1);
    end
            
    analysis.num_mol = num_mol;
    analysis.molecules = make_empty_molecules(num_mol,analysis.vid_len);    

%     params
    for i=1:num_mol
        pos = positions(i,:);
        analysis.molecules(i).initial_position = pos;
        x = pos(1);
        y = pos(2);
%         defocus_ind = 1;
        analysis.molecules(i).initial_ROI = [x-14,y-14,29,29];
        analysis.molecules(i).params = [x y defocus_inds(i) theta_inds(i) phi_inds(i)];
    end

%     analysis.molecules = molecules;

%     num_mol = analysis_info.num_mol; 
%     handles.analysis_info = analysis_info;

    






