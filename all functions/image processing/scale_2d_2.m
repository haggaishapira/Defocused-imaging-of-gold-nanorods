function [new_matrix] = scale_2d_2(old_matrix,old_x,new_x,old_y,new_y)


% [old_y,old_x] = size(old_matrix);

% if(factor)
% tic
stretched_columns_matrix = zeros(ceil(new_y),ceil(old_x));
new_matrix = zeros(ceil(new_y),ceil(new_x));

%stretch columns
for i=1:ceil(old_x)
    new_column = scale_1d_partial_pixels(old_matrix(:,i),old_y,new_y);
    stretched_columns_matrix(:,i) = new_column';
end

%stretch rows
for i=1:ceil(new_y)
    new_row = scale_1d_partial_pixels(stretched_columns_matrix(i,:),old_x,new_x);
    new_matrix(i,:) = new_row;
end
% toc