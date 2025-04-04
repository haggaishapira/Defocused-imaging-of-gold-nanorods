function pattern = get_cropped_pattern(patterns,defocus,theta,phi)

%     nn_array = [5*ones(1,6) 6:14];
%     nn_array = [4*ones(1,4) 5:14];
    nn_array = 14*ones(15,1);

    nn = nn_array(defocus);
    max_dim = nn_array(end)*2+1;
    center = 15;
    pattern = patterns(defocus,theta,phi,:,:);
    pattern = reshape(pattern, [max_dim max_dim]);
    pattern = pattern(center-nn:center+nn,center-nn:center+nn);
    pattern = pattern / sum(pattern(:));