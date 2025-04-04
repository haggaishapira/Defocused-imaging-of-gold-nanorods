function [ROI_image,int,back,S2N] = process_ROI_image(ROI_image,transform)

    ROI_image = double(ROI_image);
    % calc int back here
    [int,back] = calc_intensity(ROI_image);
    S2N = int/back;

    ROI_image = ROI_image - min(ROI_image(:));
    ROI_image = ROI_image/sum(ROI_image(:));

%     transform = 0;
    
    if transform    
        mat = zeros(29,29);
        factor = 1;
        for i=1:29
            for j=1:29
                val1 = factor*30-i*factor;
                val2 = factor*30-j*factor;
                mat(i,j) = val1+val2; 
            end
        end
        mat = mat / sum(mat(:));
%         mx_1 = max(ROI_image(:));
        
        ROI_image = ROI_image .* mat;
%         mx_2 = max(ROI_image(:));
%         ROI_image = ROI_image * mx_1/mx_2 *0.8;
        ROI_image = ROI_image/sum(ROI_image(:));

    end


    






