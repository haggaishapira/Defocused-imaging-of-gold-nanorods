function pass = distinct_peaks_filter(x,y,existing_positions,min_dist)

    pass = 1;
    for j=1:size(existing_positions,1)
        pos = existing_positions(j,:);    
        d = ((pos(1)-x)^2 + (pos(2)-y)^2)^0.5;
        if (d<min_dist)
            pass = 0;
            break;
        end
    end
        