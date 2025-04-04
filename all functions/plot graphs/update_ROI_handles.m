function handles = update_ROI_handles(handles,plot_info)

%     plot_info = handles.plot_info;
    num_mol = plot_info.num_mol_curr;
    curr_molecules = plot_info.curr_mol;
    curr_frame = plot_info.curr_frame;

    for j=1:num_mol
        molecule = curr_molecules(j);
%         real_num = molecule.real_num;
        old_ROI = molecule.ROI_handle.Position;
        new_ROI = molecule.ROI(curr_frame,:);
        if ~isequal(old_ROI,new_ROI)
            molecule.ROI_handle.Position = new_ROI;
            % update text also
            molecule.text_num.Position(1:2) = new_ROI(1:2);
        end
    end    
    
