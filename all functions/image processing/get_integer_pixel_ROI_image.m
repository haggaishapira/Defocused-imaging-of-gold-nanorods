function integer_ROI_image = get_integer_pixel_ROI_image(image,integer_ROI)

left = integer_ROI(1);
top = integer_ROI(2);
width = integer_ROI(3);
height = integer_ROI(4);

integer_ROI_image = image(top:top+height-1,left:left+width-1);
