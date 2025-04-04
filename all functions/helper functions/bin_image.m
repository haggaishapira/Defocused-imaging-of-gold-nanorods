function binned = bin_image(im,n)
    y = size(im,1);
    x = size(im,2);
    binned = zeros(y/n,x/n);
    for i=1:y/n
        for j=1:x/n
            start_y = (i-1)*n+1;
            start_x = (j-1)*n+1;
            part_im = im(start_y:start_y+n-1,start_x:start_x+n-1);
            binned(i,j) = sum(part_im(:));
        end
    end