function dwells = calculate_dwells(settings,t, phi)


    dwells = [];
    dwelling = 0; 
%     dwell.dwell_time = 0;
%     dwell.start_time = 0;
%     dwell.end_time= 0;
%     dwell.phi = 0;
    max_range = settings.max_range;

    len = length(phi);
    for i=1:len
        curr_phi = phi(i);
        if ~dwelling
           start_frame = i;
           min_phi = curr_phi;
           max_phi = curr_phi;
           range = 0;
           dwelling = 1;
        else 
            if curr_phi<min_phi
                range = range + (min_phi - curr_phi);
                min_phi = curr_phi;                
            end
            if curr_phi>max_phi
                range = range + (curr_phi - max_phi);    
                max_phi = curr_phi;   
            end
            % end of dwell?
            if range > max_range
                dwell_time = t(i-1) - t(start_frame);
                if dwell_time > 0
                    dwell = zeros(4,1);
                    dwell(1) = dwell_time;
                    dwell(2) = t(start_frame);
                    dwell(3) = t(i-1);
                    dwell(4) = mean(phi(start_frame:i-1));
                    dwells = [dwells dwell];
                end
                dwelling = 0;
            end
        end
    end
    



