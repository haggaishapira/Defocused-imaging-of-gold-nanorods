function deviation_from_free_rotation = calculate_deviation_from_free_rotation(phi)

%     phi = molecule.phi_half(1:end);
    phi = mod(phi,180);
    counts = histcounts(phi,'BinWidth',5,'BinLimits',[0 180]);
    norm_counts = counts / sum(counts);
    even_dist = ones(1,length(norm_counts));
    even_dist = even_dist / sum(even_dist);
%     sqs = (even_dist - norm_counts) .^ 2;
    diff = abs(even_dist - norm_counts);

    deviation_from_free_rotation = sum(diff);
%     deviation_from_free_rotation = sum(sqs);
