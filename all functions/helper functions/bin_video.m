function binned_vid = bin_video(video,bin)
    [sz_y,sz_x,len] = size(video);
    new_len = floor(len/bin);
    binned_vid = zeros(sz_y,sz_x,new_len);
    counter = 1;
    for i=1:bin:len
        segment = video(:,:,(i-1)*bin+1:i*bin);
        binned_segment = sum(segment,3);
        binned_vid(:,:,counter) = binned_segment;
    end