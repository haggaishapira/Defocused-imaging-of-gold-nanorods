function smoothed_image = smooth_image(image)

%smooth 3 by 3

[size_y,size_x] = size(image);
smoothed_image = zeros(size(image));

surround = [-1 -1; -1 0; -1 1; 0 -1; 0 1; 1 -1; 1 0; 1 1];

for i=1:size_y
    for j=1:size_x
        counter = 0;
        for k = 1:length(surround)
            y = i + surround(k,1);
            x = j + surround(k,2);
            if y>=1 && y<=size_y && x>=1 && x<=size_x
                smoothed_image(i,j) = smoothed_image(i,j) + image(i,j) + image(y,x);
                counter = counter+2;
            end
        end
        smoothed_image(i,j) = smoothed_image(i,j)/counter;
    end
end





    