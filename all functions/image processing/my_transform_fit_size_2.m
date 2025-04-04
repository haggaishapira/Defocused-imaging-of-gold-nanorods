function [new_image] = my_transform_fit_size_2(old_image,old_x,new_x,old_y,new_y,tx,ty)

if old_x==new_x && old_y==new_y && tx==0 && ty==0
    new_image = old_image;
else
    scaled = scale_2d_2(old_image,old_x,new_x,old_y,new_y);
    transformed_image = translate_2d(scaled,tx,ty); 
    new_image = transformed_image(1:ceil(new_y),1:ceil(new_x));
        
    if isequal(class(old_image), 'uint8')
        new_image = uint8(new_image);
    else if isequal(class(old_image), 'uint16')
            new_image = uint16(new_image);
        end
    end
end
