function cropped_im = crop_image(im,lims)
    
    left = lims(1);
    right = lims(2);
    top = lims(3);
    bottom = lims(4);
    cropped_im = im(left:right,top:bottom);