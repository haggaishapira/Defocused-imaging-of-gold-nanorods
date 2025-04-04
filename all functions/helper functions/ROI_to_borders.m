function borders = ROI_to_borders(ROI)

left = ROI(1);
top = ROI(2);
right = ROI(1)+ ROI(3)-1;
bottom = ROI(2)+ ROI(4)-1;
borders = [left top right bottom]; 