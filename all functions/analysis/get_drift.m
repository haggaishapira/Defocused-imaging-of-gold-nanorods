function [new_dx,new_dy,diff_phase,error] = get_drift(ref_frame,new_frame,current_dx,current_dy)


%     center_x = analysis_info.center_x;
%     center_y = analysis_info.center_y;

%     ref_frame = analysis_info.reference_frame;
%     ref_ROI_rad = analysis_info.ref_ROI_rad;
%     max_drift = analysis_info.max_drift;

    % hill climbing method
%     pix_cut = analysis_info.pix_cut;
%     [new_dy,new_dx] = correlation_hill_climbing(curr_frame, reference_frame,current_dy,current_dx, center_x,center_y,pix_cut);
%     [new_dy,new_dx] = correlation_hill_climbing(ref_frame,new_frame, ref_ROI_rad, center_x, center_y, current_dx, current_dy, max_drift);

    % sub pixel correlation fourier method
    buf1ft = fft2(ref_frame);
    buf2ft = fft2(new_frame);
    upsampling_factor = 100;
    [output,buf2ft_corrected] = dftregistration(buf1ft,buf2ft,upsampling_factor);
%      corrected_frame = abs(ifft2(buf2ft_corrected));
%      new_dy = round(output(3));
%      new_dx = round(output(4));
    new_dy = output(3);
    new_dx = output(4);
    diff_phase = output(2);
    error = output(1);
%     disp(new_dx);
%     disp(new_dy);

%%%%%%%%%%%%%%%% old
%     current_dy = analysis_info.current_dy;
%     current_dx = analysis_info.current_dx;

%     corrected_ROIs = zeros(4,num_mol);
%     num_frames = 10;
%     current_frames = zeros(512,512,num_frames);
%     for i=1:num_frames
%         frame = get_frame(handles,curr_frame-num_frames+i);  
%         current_frames(:,:,i) = frame;
%     end
%     current_frames = double(current_frames);
%     new_frame = sum(current_frames,3)/num_frames;
%     new_frame = crop_image(new_frame,analysis_info.reference_frame_lims);
    







