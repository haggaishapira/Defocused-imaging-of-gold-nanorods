function fit = calculate_ring_fitting(frame,ring,x,y)
    
    ROI_im = frame(y-14:y+14,x-14:x+14);
%     nn = 11;
%     center_ring = 15;
%     ring = ring(center_ring-nn:center_ring+nn,center_ring-nn:center_ring+nn);

%     ROI_im = frame(y-nn:y+nn,x-nn:x+nn);
    
    ROI_im = ROI_im/sum(ROI_im(:));
    ROI_im = ROI_im(ring>0);
    fit = sum(ROI_im(:));
    
    