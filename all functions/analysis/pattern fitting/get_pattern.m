function pattern = get_pattern(handles,theta,phi,defocus_ind,flat)

%     patterns = get_patterns(handles,defocus_ind,1,flat);
%     pattern = squeeze(patterns(theta/10+1,phi/5+1,:,:));
    pattern = handles.patterns(defocus_ind,theta/10+1,phi/5+1,:,:);
    pattern = squeeze(pattern);
