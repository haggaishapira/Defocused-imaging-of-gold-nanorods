function ROI = borders_to_ROI(borders)
    left = borders(1);
    top = borders(2);
    width = borders(3)-borders(1)+1;
    height = borders(4)-borders(2)+1;
    ROI = [left top width height];