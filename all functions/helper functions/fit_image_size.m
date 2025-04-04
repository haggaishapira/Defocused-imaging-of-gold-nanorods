function [new_image] = fit_image_size(image,reference)

if size(image) == size(reference)
    new_image = image;
else
    [y1,x1] = size(image);
    [y2,x2] = size(reference);
    new_image = zeros(size(reference));
    min_y = min(y1,y2);
    min_x = min(x1,x2);
    new_image(1:min_y,1:min_x) = image(1:min_y,1:min_x);
end