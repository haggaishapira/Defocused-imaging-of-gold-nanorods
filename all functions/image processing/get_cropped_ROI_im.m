function ROI_im = get_cropped_ROI_im(full_im,x,y,defocus,transform)

%     nn_array = [5*ones(1,6) 6:14];
%     nn_array = [4*ones(1,4) 5:14];
    nn_array = 14*ones(15,1);

    try
        nn = nn_array(defocus);
    catch e
        1
    end
    ROI_im = full_im(y-nn:y+nn,x-nn:x+nn);
    [ROI_im,~,~,~] = process_ROI_image(ROI_im,transform);