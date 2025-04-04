function phi = smooth_phi(phi,sequence_info,analysis)

    phi = phi - phi(1) - 20;
    new_phi = zeros(length(phi),1);
%                 cycle_frames = 62366;
%                 num_cycles = ceil(length(phi)/cycle_frames);
    % iterate by segments
    cycle_num = 1;
    for i=1:60:sequence_info.total_num_steps
        t_start = sequence_info.time_intervals(i,1);
        if t_start > last_t
            continue;
        end
        t_end = sequence_info.time_intervals(min(i+59,sequence_info.total_num_steps),2);
        t_end = min(t_end,last_t);
        t_interval = t(t>=t_start & t<t_end);
        frames = round(t_interval * analysis.framerate);
        phi_seg = phi(frames);
        phi_seg = mod(phi_seg,180) + (cycle_num-1) * 180;

        %%% further processing %%%
        middle_frame = round(length(phi_seg) / 2);
%                     mid_expected_phi = (cycle_num-1) * 360 + 180;
        three_quarters_expected_phi = (cycle_num-1) * 180 + 135;
        quarter_expected_phi = (cycle_num-1) * 180 + 45;
%                     phi_seg_first_half = phi_seg(1:middle_frame);
%                     phi_seg_second_half = phi_seg(middle_frame+1:end);
        for j=1:middle_frame
            if phi_seg(j)>three_quarters_expected_phi
                phi_seg(j) = phi_seg(j) - 180;
            end
        end
        for j=middle_frame+1:length(phi_seg)
            if phi_seg(j)<quarter_expected_phi
                phi_seg(j) = phi_seg(j) + 180;
            end
        end
%                     phi_seg_first_half(phi_seg_first_half>three_quarters_expected_phi) = ...
%                         phi_seg_first_half(phi_seg_first_half>three_quarters_expected_phi) - 180;
%                     phi_seg_second_half(phi_seg_second_half<quarter_expected_phi) = ...
%                         phi_seg_second_half(phi_seg_second_half<quarter_expected_phi) + 180;
%                     phi_seg = [phi_seg_first_half; phi_seg_second_half];
        %%% further processing %%%
        new_phi(frames) = phi_seg;
%                     phi(frames) = phi_seg;
        cycle_num = cycle_num + 1;
        % start with F3, or just go every x intervals?
    end
    %%

    % iterate by frame cycle
%                 for i=1:num_cycles
%                     frames = (1:cycle_frames) + (i-1) * cycle_frames;
%                     if i == num_cycles
%                         frames(frames>length(phi)) = [];
%                     end
%                     phi_seg = phi(frames);
%                     phi_seg = mod(phi_seg,360) + (i-1) * 360;
%                     phi(frames) = phi_seg;
%                 end
    phi = new_phi;