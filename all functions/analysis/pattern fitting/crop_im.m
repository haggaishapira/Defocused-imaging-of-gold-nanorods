function cropped = crop_im(im,new_nn)
    old_dim = size(im,1);
    old_nn = old_dim/2-1;
    d = old_nn - new_nn;
    cropped = im(1+d:old_dim-d,1+d:old_dim-d);
    