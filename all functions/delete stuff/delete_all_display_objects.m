function handles = delete_all_display_objects(handles,file_num)

    % getting the file num as variable is safer

    % requires correct file num
%     file_num = handles.current_file_num;
    if file_num > 0
        try
            analysis = handles.analyses(file_num);
            switch analysis.analysis_mode
                case 'rotation'
                    [molecules,num_mol] = get_current_molecules(handles);
                    if num_mol > 0           
                        [molecules,num_mol] = get_current_molecules(handles);
                        for i=1:num_mol
                            delete_molecule_display_objects(molecules(i));
                        end
                    end
                case 'immobilization'
                    delete(handles.all_immobilized_mol_plot);
                    delete(handles.uncrowded_immobilized_mol_plot);
            end
        catch e
        end
    end

    ROI_handles = handles.registered_positions_ROI_handles;
    num_ROIs = size(ROI_handles,1);
    for i=1:num_ROIs
%         try
            delete(ROI_handles(i));
%         catch e
%         end
    end
    handles.registered_positions_ROI_handles = [];

