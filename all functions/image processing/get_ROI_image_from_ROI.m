function ROI_image = get_ROI_image_from_ROI(frame,ROI)

left = ROI(1);
top = ROI(2);
width = ROI(3);
height = ROI(4);

ROI_image = frame(top:top+height-1,left:left+width-1);
