function [ROI_image,ROI] = get_ROI_im_from_center(frame,center_x,center_y,rad)

    ROI = get_ROI_from_center(center_x,center_y,rad);
    ROI_image = get_ROI_image_from_ROI(frame,ROI);