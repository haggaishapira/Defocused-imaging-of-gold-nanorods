function refined_free = calculate_free(d_phi)

%     d_phi = molecule.d_phi;
%         released = d_phi>=40;
    len = length(d_phi);

    free = d_phi>=40;
    refined_free = free;
    rad = 10;
    for i=rad+1:len-rad
        if ismember(1,free(i-rad:i+rad))
            refined_free(i) = 1;
        end
    end
    