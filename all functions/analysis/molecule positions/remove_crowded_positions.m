function [uncrowded_positions,num_uncrowded] = remove_crowded_positions(all_positions,distance_matrix,ints,min_distance_pixels)

    total_num_mol = size(all_positions,1);
    
    % num_mol_uncrowded
    crowded_positions = zeros(total_num_mol,1);

    for i=1:total_num_mol
        for j=1:total_num_mol
            if i == j
                continue;
            end
            d = distance_matrix(i,j);
            if (d<min_distance_pixels)
                if ints(i)>ints(j)
                    smaller = j;
                    ratio = ints(i)/ints(j);
                else
                    smaller = i;
                    ratio = ints(j)/ints(i);
                end
                if ratio > 1.7
                    crowded_positions(smaller) = 1;
                else
                    crowded_positions(i) = 1;
                    crowded_positions(j) = 1;
                end

%                 crowded_positions(i) = 1;
%                 crowded_positions(j) = 1;

%                 fprintf('first int: %f, second int: %f\n', ints(i),ints(j));
%                 fprintf('first pos: %f %f, second pos: %f %f\n\n', pos1(1),pos1(2),pos2(1),pos2(2));
            end
        end
    end

    if ~isempty(crowded_positions)
        crowded_positions = find(crowded_positions);
        fprintf('removing %d molecules from crowded positions\n', length(crowded_positions));
        all_positions(crowded_positions,:) = [];
    end
    uncrowded_positions = all_positions;
    num_uncrowded = size(uncrowded_positions,1);









