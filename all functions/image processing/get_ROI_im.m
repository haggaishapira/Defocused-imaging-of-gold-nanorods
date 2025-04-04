function im = get_ROI_im(ROI,frame)
        left = ROI(1);
        top = ROI(2);
        right = ROI(1) + ROI(3) - 1;
        bottom = ROI(2) + ROI(4) - 1;
        im = frame(top:bottom,left:right);
