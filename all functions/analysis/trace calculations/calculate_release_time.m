function [release_time,release_frame] = calculate_release_time(settings,d_phi,framerate,first_frame,last_frame)

    release_d_phi_threshold = settings.release_d_phi_threshold;
    release_min_t = settings.release_min_t;

    actual_anti_fuel_time = 30;
    actual_anti_fuel_frame = round(first_frame + actual_anti_fuel_time * framerate);

    found = 0;
%     already_released = 0;
%     release_d_phi_threshold = 50; % smaller than this diff
%     d_phi = molecule.d_phi(first:last);

    % have at least x frames of stuck
    threshold_time = 20; % sec
    threshold_frames = round(threshold_time * framerate);
    counter = 0;
    for i=first_frame:last_frame
        if d_phi(i) >= release_d_phi_threshold
            
            if i < actual_anti_fuel_frame
                break;
            end

            release_frame = i;
            found = 1;

            break;
        end
        counter = counter + 1;
    end

    if ~found
        release_frame = inf;        
    end
    release_time = release_frame/framerate;




