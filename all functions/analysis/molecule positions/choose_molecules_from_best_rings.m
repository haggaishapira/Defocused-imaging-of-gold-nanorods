function [ROIs,lst_sqs,num_found] = choose_molecules_from_best_rings(analysis_info,analysis_settings,...
                                    sorted_inds, ROI_dim, result_matrix, patterns)


% choose_molecules_from_best_rings(analysis_info,analysis_settings,sorted_inds, ROI_dim, result_matrix, current_patterns);

    num_mol = analysis_settings.num_molecules;

    ROIs = [];
    num_added_mol = 0;
%     mol_locs = zeros(num_mol,2);
    enough_molecules = false;
    lst_sqs = [];
    rad = ROI_dim/2-1;
    frame1 = analysis_info.frame1;
    filter_by_S2N = analysis_settings.filter_by_S2N;

%     i = 1;
    for i = 1:length(sorted_inds)
        too_close = false;
        [y,x] = ind2sub(size(result_matrix),sorted_inds(i));
        center_x = x+rad;
        center_y = y+rad;
        ROI = [x y ROI_dim ROI_dim];

        if ROI_out_of_bounds(analysis_settings,ROI)
            continue;
        end
        if molecule_too_close(ROI,ROIs,num_added_mol)
            continue;
        end

        %if error too large, discard
        ROI_image = get_integer_pixel_ROI_image(frame1, ROI);
        [ROI_image,int,back,S2N] = process_ROI_image(ROI_image);
        if filter_by_S2N && signal_to_noise_too_low(analysis_settings,S2N)
            continue;
        end

%             [~,~,lst_sq] = fit_pattern_least_squares(ROI_image(:), patterns);
        [~,~,lst_sq] = fit_pattern_lsq_hill_climbing(patterns,ROI_image(:),ROI_dim);
        if lst_sq < 0.001 
            lst_sqs = [lst_sqs lst_sq];
%                 mol_locs(num_added_mol,:) = [y x];
            ROIs = [ROIs; ROI];
            num_added_mol = num_added_mol + 1;
        end
        if num_added_mol == num_mol
            break;
        end
    end

    num_found = num_added_mol;











    


    