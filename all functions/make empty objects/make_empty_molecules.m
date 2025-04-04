function molecules = make_empty_molecules(num_mol,vid_len)
    
    molecules = [];
%now use rois
    for i=1:num_mol
%         ROI = ROIs(i,:);
%         lst_sq = lst_sqs(i);
%         focus = focuses(i);
        molecule = make_empty_molecule(i,vid_len);
        molecules = [molecules molecule];       
    end