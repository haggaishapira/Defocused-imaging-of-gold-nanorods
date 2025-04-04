function [immobilization_time,immobilization_frame] = calculate_immobilization_time(settings,d_phi,framerate,first_frame,last_frame)

    actual_fuel_time = 30;
    actual_fuel_frame = round(first_frame + actual_fuel_time * framerate);

    immobilization_d_phi_threshold = settings.immobilization_d_phi_threshold; % smaller than this dif
    immobilization_min_window_time = settings.immobilization_min_window_time;
    min_window_frames = round(immobilization_min_window_time*framerate);
%         d_phi_reverse = flip(molecule.d_phi,1);
    
    stuck_frames = 0;
%     stuck = 0;
%         d_phi = molecule.d_phi;

    found = 0;
    initially_free = 0;

    for i=first_frame:last_frame
        if d_phi(i) <= immobilization_d_phi_threshold
            stuck_frames = stuck_frames + 1;
            if stuck_frames >= min_window_frames && ~found && initially_free
                immobilization_frame = i - min_window_frames + 1;
                % immobilization_relative_time = (immobilization_frame - first_frame)/framerate;
                % if immobilization_relative_time > 5 
                    found = 1;
                % end
                break;
            end
        else
            if i < actual_fuel_frame
                initially_free = 1;
            end
            stuck_frames = 0;
            found = 0;
        end
    end
    if ~found
        immobilization_frame = inf;
    end

    immobilization_time = immobilization_frame/framerate;

    % disp(first_frame);
    % disp(immobilization_time);
    



















