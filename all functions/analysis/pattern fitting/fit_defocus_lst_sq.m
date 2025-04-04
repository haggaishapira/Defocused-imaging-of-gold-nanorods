function [new_ROI,new_defocus] = fit_defocus_lst_sq(handles,frame,center_x,center_y,theta,phi)

    nn_array = handles.nn_array;
    num_defocuses = get_num_defocuses(handles);
    defocus_array = get_defocus_array(handles);

    center_x = old_ROI(1) + (old_ROI(3)-1)/2;
    center_y = old_ROI(2) + (old_ROI(4)-1)/2;
    
    lst_sum_sq = inf;
    defocus_ind = 1;        
    new_ROI = old_ROI;

    sm_sqs = zeros(num_defocuses,1);
    
    for i=1:num_defocuses
        rad = nn_array(i);
        [ROI_image,ROI] = get_ROI_im_from_center(frame,center_x,center_y,rad);
        [ROI_image,~,~,~] = process_ROI_image(ROI_image);
        pattern = get_pattern(handles,theta,phi,i,0);
        sqs = (ROI_image - pattern) .^ 2;
        sm_sqs(i) = sum(sqs(:));
        if sm_sqs(i) < lst_sum_sq
            lst_sum_sq = sm_sqs(i);
            defocus_ind = i;
            new_ROI = ROI;
        end
    end
    new_defocus = defocus_array(defocus_ind);







    
