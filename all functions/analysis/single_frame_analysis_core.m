function [analysis_info,temp_molecules,tot_int,corr_x,corr_y] = single_frame_analysis_core(handles,analysis_info,frame,i,molecules,num_mol)

    analysis_settings = handles.analysis_settings;
    perform_stage_correction = analysis_settings.stage_shift_tracking && ~mod(i,analysis_info.stage_interval_frames) && i>=10;

    tot_int = sum(frame(:));
    if perform_stage_correction
        set(handles.ax_video.Children(end),'CData',frame);
        [analysis_info, stage_corrected_ROIs,corrected_stage,corr_x,corr_y] = stage_correction(handles,analysis_info,i,molecules,num_mol); 
    else
        [corr_x,corr_y] = deal(0,0);
    end
    
    % make new temp struct
    temp_molecules = [];

    for j=1:num_mol
%             molecule = molecules(j);
        if perform_stage_correction && corrected_stage
            ROI = stage_corrected_ROIs(:,j);
        else
            ROI = molecules(j).ROI(:,max(i-1,1));
        end
        focus = molecules(j).focus(max(i-1,1));
        ROI_image = get_integer_pixel_ROI_image(frame, ROI);
        [ROI_image,int,back,S2N] = process_ROI_image(ROI_image);
%             molecules(j).int(i) = int;
%             molecules(j).back(i) = back;

        temp_molecule.int = int;
        temp_molecule.back = back;

        if analysis_settings.common_focus
            patterns = get_patterns(handles,analysis_info.current_focus_ind,1,1);
            ROI_dim = analysis_info.ROI_dim;
        else
            ROI_dim = size(ROI_image,1);
            focus_ind = ROI_dim_to_focus_ind(handles,ROI_dim);
            patterns = get_patterns(handles,focus_ind,1,1);
        end
        [theta,phi,lst_sq] = fit_pattern_lsq_hill_climbing(patterns, ROI_image(:),ROI_dim);                    

        if analysis_settings.focus_shift_tracking && ~mod(i,analysis_info.focus_interval_frames)
            if ~analysis_settings.common_focus
                [ROI,focus] = single_molecule_focus_correction(handles,frame,ROI,theta,phi);
            end
        end
%             molecules(j) = process_and_save_angle_info(i,molecules(j),theta,phi);
%             molecules(j).ROI(:,i) = ROI;
%             molecules(j).focus(i) = focus;
%             molecules(j).lst_sq_video(i) = lst_sq;

            temp_molecule = process_and_save_angle_info(i,molecules(j),theta,phi, temp_molecule);
            temp_molecule.ROI = ROI;
            temp_molecule.focus = focus;
            temp_molecule.lst_sq_video = lst_sq;
            
            temp_molecules = [temp_molecules; temp_molecule];

%             fprintf('\ndone molecule %d\n', j);
    end   

