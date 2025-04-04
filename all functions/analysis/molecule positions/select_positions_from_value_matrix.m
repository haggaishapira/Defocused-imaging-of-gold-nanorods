function [selected_positions,selected_vals,num_mol] = select_positions_from_value_matrix(borders,matrix,min_dist,min_val)

    % sort all pixels by intensity
    [~,inds] = sort(matrix(:),'descend');
    [ys,xs] = ind2sub(size(matrix),inds);

    selected_positions = [];
    selected_vals = [];
    num_mol = 0;

    for i=1:length(ys)
        y = ys(i);
        x = xs(i);
        
        if ~position_filter(x,y,borders)
            continue;
        end

        curr_val = matrix(y,x);
        if curr_val<min_val
            break; % from here everything is lower by definition
        end 

        % get peaks which are at least 1500nm apart - otherwise they might
        % be pixels of the same molecule
%         distinct_peak_distance = 10;
        if ~distance_filter(x,y,selected_positions,min_dist)
            continue;
        end

        selected_positions = [selected_positions; x y];     
        selected_vals = [selected_vals; curr_val];
        num_mol = num_mol + 1;    

    end





