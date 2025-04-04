function [angle,lst_sq] = fit_pattern_centroid(ROI_image, patterns)
%     num_pat = size(patterns,2);
%     lst_sq = inf;
%     angle = 1;
%     for i=1:num_pat
%         sqs = (ROI_image - patterns(:,i)) .^ 2;
%         sm = sum(sqs(:));
%         if sm < lst_sq
%             lst_sq = sm;
%             angle = i;
%         end
%     end
    %find dark place
%     a=2;
%     ROI_image = 
    lst_sq = 0;
    dim = size(ROI_image,1);
    rad = (dim-1)/2;
    large_disk = Disk(rad);
    small_rad = round(0.5*rad);
    small_disk = Disk(small_rad); 
    mod_small_disk = zeros(dim);
    mod_small_disk(rad-small_rad+1:rad+small_rad+1,rad-small_rad+1:rad+small_rad+1) = small_disk;
    ring = ~mod_small_disk & large_disk;
    mn = min(ROI_image(ring));
    mx = max(ROI_image(ring));
    image_1 = ROI_image;
    image_1(ring) = interp1([mn mx],[0 255],image_1(ring));
    image_1(~ring) = 0;
    image_2 = ones(dim);
    image_2(~ring) = 0;
    image_2(ring) = 255;
    image_3 = image_2-image_1;
    sm_y = 0;
    sm_x = 0;
    for y=1:dim
        for x=1:dim
           sm_y = sm_y + y * image_3(y,x);
           sm_x = sm_x + x * image_3(y,x);
        end
    end
    cent_y = sm_y / sum(image_3(:));
    cent_x = sm_x / sum(image_3(:));
    cent_y = -(cent_y - rad - 1);
    cent_x = cent_x - rad - 1;
    phi = atan(cent_y/cent_x) * 360 /2/pi;
    phi = mod(phi,360);
    if cent_x<0
        phi = mod(phi+180,360);
    end
    temp_phi = phi - mod(phi,5);
%     disp(phi);
    lst_sq = inf;
    angle = 1;
    for i=0:9
        pat_ind = 1 + 72*i + temp_phi/5;
        pat = patterns(:,pat_ind);
        sqs = (ROI_image(:) - pat) .^ 2;
        sm = sum(sqs(:));
        if sm < lst_sq
            lst_sq = sm;
            angle = pat_ind;
        end
    end
    
    
    
    
    
    
    
    
    
    
    