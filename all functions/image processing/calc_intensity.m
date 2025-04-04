function [int,back] = calc_intensity(ROI_image)
    [y,x] = size(ROI_image);
    try
        back_area = [ROI_image(1:y,1)' ROI_image(1,2:x) ROI_image(2:y,x)' ROI_image(y,2:x-1)];
    catch e
        1;
    end
    back_avg_val = sum(back_area(:))/length(back_area);
    back = back_avg_val*x*y;
    int = sum(ROI_image(:)) - back;
