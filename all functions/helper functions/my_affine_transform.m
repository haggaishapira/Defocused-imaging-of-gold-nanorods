function [new_matrix] = my_affine_transform(old_matrix,sx,sy)

% old_matrix = double(old_matrix);

% [old_y,old_x]= size(old_matrix);
if sx == 1 & sy == 1
    new_matrix = old_matrix;
else
    T = [sx 0 0;
         0 sy 0;
         0 0 1];
    tform = affine2d(T);
    new_matrix = imwarp(old_matrix,tform);
end


if isequal(class(old_matrix), 'uint8')
    new_matrix = uint8(new_matrix);
else if isequal(class(old_matrix), 'int8')
        new_matrix = int8(new_matrix);
    end
end