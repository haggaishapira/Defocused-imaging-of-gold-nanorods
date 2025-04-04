function molecules = add_molecule_ROI_handles(handles, molecules, initial_ROI)

    num_mol = size(molecules,2);
    curr_frame = round(handles.slider_frames.Value);

    for i=1:num_mol
        if initial_ROI
            ROI = molecules(i).initial_ROI;
        else
            ROI = molecules(i).ROI(curr_frame,:);
        end
         molecules(i).ROI_handle = add_ROI(handles,ROI);
    end

    toggle_ROIs(handles,molecules,num_mol);

