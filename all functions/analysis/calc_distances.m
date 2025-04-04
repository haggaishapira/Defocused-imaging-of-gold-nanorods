function [distance_matrix,min_distances] = calc_distances(positions)


    num_mol = size(positions,1);
    distance_matrix = zeros(num_mol);
    min_distances = inf*ones(num_mol,1);

    % calc distance matrix
     for i=1:num_mol
        pos1 = positions(i,:);
        for j=1:num_mol
            if i == j
                continue;
            end
            pos2 = positions(j,:);
            d = ((pos1(1)-pos2(1))^2 + (pos1(2)-pos2(2))^2)^0.5;
            distance_matrix(i,j) = d;
            if d < min_distances(i)
                min_distances(i) = d;
            end
        end
     end