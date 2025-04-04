function [analysis_info,corrected_ROIs,correction,delta_x,delta_y] = stage_correction(handles,analysis_info,curr_frame,molecules,num_mol)

    current_dy = analysis_info.current_dy;
    current_dx = analysis_info.current_dx;

    corrected_ROIs = zeros(4,num_mol);
    
    num_frames = 10;
    current_frames = zeros(512,512,num_frames);
    for i=1:num_frames
        frame = get_frame(handles,curr_frame-num_frames+i,0);  
        current_frames(:,:,i) = frame;
    end
    current_frames = double(current_frames);
    new_frame = sum(current_frames,3)/num_frames;
%     new_frame = crop_image(new_frame,analysis_info.reference_frame_lims);

    reference_frame = analysis_info.reference_frame;

    % hill climbing method
    pix_cut = analysis_info.pix_cut;
    [best_dy,best_dx] = correlation_hill_climbing(new_frame, reference_frame,current_dy,current_dx, pix_cut);
    delta_y = best_dy - current_dy;
    delta_x = best_dx - current_dx;
    correction = delta_y ~= 0 || delta_x ~= 0;

    % complete calculation method
%     if correction
% %         pix_cut = 20;   
%         c = normxcorr2(reference_frame,new_frame);
%         [ypeak,xpeak] = find(c==max(c(:)));
%         delta_y = ypeak-size(reference_frame,1) - pix_cut;
%         delta_x = xpeak-size(reference_frame,2) - pix_cut;
%         figure
%         surf(c)
%         shading flat
%         1;
%     end
    
    if correction
%         disp(curr_frame);
%         disp('corrected drift');
%         correction = 1;
        analysis_info.current_dy = best_dy;
        analysis_info.current_dx = best_dx;
        for j=1:num_mol
            h = molecules(j).ROI_handle;
            ROI = h.Position;
            ROI(1) = ROI(1) + delta_x;
            ROI(2) = ROI(2) + delta_y;
            h.Position = ROI;
            corrected_ROIs(j,:) = ROI;
        end   
    end
       

    







