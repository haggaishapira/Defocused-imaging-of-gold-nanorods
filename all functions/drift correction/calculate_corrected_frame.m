function corrected_frame = calculate_corrected_frame(frame,row_shift,col_shift,diffphase)  

    buf2ft = fft2(frame);
    [nr,nc]=size(buf2ft);

    Nc = ifftshift(-fix(nc/2):ceil(nc/2)-1);
    Nr = ifftshift(-fix(nr/2):ceil(nr/2)-1);
    [Nc,Nr] = meshgrid(Nc,Nr);
    Greg = buf2ft.*exp(1i*2*pi*(-row_shift*Nr/nr-col_shift*Nc/nc));
    Greg = Greg*exp(1i*diffphase);
    corrected_frame_ft = Greg;
    
    corrected_frame = abs(ifft2(corrected_frame_ft));
