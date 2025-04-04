function patterns = normalize_patterns(patterns)

    sz = size(patterns);
%     num_dim = length(sz) - 2;
    
    for i=1:sz(1)
        for j=1:sz(2)
            for k=1:sz(3)
                pat = patterns(i,j,k,:,:);
                pat = reshape(pat,[sz(4) sz(5)]);
                pat = pat / sum(pat(:));
                patterns(i,j,k,:,:) = pat;
            end
        end
    end
