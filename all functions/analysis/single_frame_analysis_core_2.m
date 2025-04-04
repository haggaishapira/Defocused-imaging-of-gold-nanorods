function [analysis_info,temp_molecules,tot_int] = single_frame_analysis_core_2(handles,analysis_info,frame,i,molecules,num_mol,...
                                                                                fit_xy_single_molecule,calibration,max_dist,params_to_opt,max_defocus_ind)

%     perform_stage_correction = analysis_settings.stage_shift_tracking && ~mod(i,analysis_info.stage_interval_frames) && i>=10;
    rings = analysis_info.rings;
    tot_int = sum(frame(:));
    
    % not really collapsing\averaging... just to remember this is the case
    % - maybe changing this will improve this tracking
    collapse = frame;
    
    % make new temp struct
    temp_molecules = [];

    for j=1:num_mol
%             molecule = molecules(j);
%         if perform_stage_correction && corrected_stage
%             ROI = stage_corrected_ROIs(:,j);
%         else
%             ROI = molecules(j).ROI(:,max(i-1,1));
%         end
%         focus = molecules(j).focus(max(i-1,1));
%         ROI_image = get_integer_pixel_ROI_image(frame, ROI);
%         [ROI_image,int,back,S2N] = process_ROI_image(ROI_image);
%             molecules(j).int(i) = int;
%             molecules(j).back(i) = back;

  
%         if analysis_settings.common_focus
%             patterns = get_patterns(handles,analysis_info.current_focus_ind,1,1);
%             ROI_dim = analysis_info.ROI_dim;
%         else
%             ROI_dim = size(ROI_image,1);
%             focus_ind = ROI_dim_to_focus_ind(handles,ROI_dim);
%             patterns = get_patterns(handles,focus_ind,1,1);
%         end

%         [theta,phi,lst_sq] = fit_pattern_lsq_hill_climbing(patterns, ROI_image(:),ROI_dim);

        
%         finished_position_time = 5;
%         finished_position_frame = 250;
%         finished_dofocus_frame = 250;

%         if analysis_info.ring_fitting
%             params_to_opt = 3:5;
%             % rings are used to fit position. don't fit position based on
%             % pattern fitting (which is different than ring fitting)
%         else
% %             fit_position_now = 
%             if i<analysis_info.finished_position_frame
%                 params_to_opt = 1:5;
%             else
%                 params_to_opt = 3:5;
%             end
%         end
%         params_to_opt = 4:5;


%         if i==1
%             params_init = molecules(j).params_init;
%         else
%             params_init = molecules(j).params(i-1,:);
%         end
        current_params = molecules(j).params;
%         if analysis_info.fit_xy_cross_correlation
%             current_params(1:2) = current_params(1:2) + [curr_dx curr_dy];
%         end
        x_initial =  molecules(j).initial_position(1);
        y_initial =  molecules(j).initial_position(2);
        
        % full least squares
%         [best_params,lst_sq] = fit_pattern_least_squares_2(frame, handles.patterns, current_params);
        
        % gradient descent
        [best_params,lst_sq] = fit_pattern_lsq_gradient_descent(frame, handles.patterns, current_params,calibration,x_initial,y_initial,...
                                            rings, collapse, fit_xy_single_molecule, params_to_opt ,max_dist,analysis_info.min_theta_ind,...
                                            analysis_info.transform(j),analysis_info.max_defocus_ind);



%         analysis_info.current_params(j,:) = best_params;
%         temp_molecule.int = int;
%         temp_molecule.back = back;
        temp_molecule.x = best_params(1);
        temp_molecule.y = best_params(2);
        temp_molecule.params = best_params;
        temp_molecule.defocus = (best_params(3)-1)/-10;
        y = temp_molecule.y;
        x = temp_molecule.x;
        ROI = [x-14 y-14 29 29];
        ROI_im = frame(y-14:y+14,x-14:x+14);
        theta = (best_params(4)-1) * 10;
        phi = (best_params(5)-1)*5;
%         ROI_dim = size(ROI_im,1);
%         nn = (ROI_dim-1)/2;
%         left = temp_molecule.x - nn;
%         top = temp_molecule.y - nn;
%         ROI_im = get_ROI_im(ROI,frame);
        [ROI_im,temp_molecule.int,temp_molecule.back,~] = process_ROI_image(ROI_im,analysis_info.transform(j));

%         if analysis_settings.focus_shift_tracking && ~mod(i,analysis_info.focus_interval_frames)
%             if ~analysis_settings.common_focus
%                 [ROI,focus] = single_molecule_focus_correction(handles,frame,ROI,theta,phi);
%             end
%         end
%             molecules(j) = process_and_save_angle_info(i,molecules(j),theta,phi);
%             molecules(j).ROI(:,i) = ROI;
%             molecules(j).focus(i) = focus;
%             molecules(j).lst_sq_video(i) = lst_sq;

        temp_molecule = process_and_save_angle_info(i,molecules(j),theta,phi, temp_molecule);
        temp_molecule.ROI = ROI;
        
        temp_molecule.lst_sq_video = lst_sq;
        
        temp_molecules = [temp_molecules; temp_molecule];

%             fprintf('\ndone molecule %d\n', j);
    end   

