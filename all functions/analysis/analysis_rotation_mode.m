function analysis = analysis_rotation_mode(handles,analysis_settings,analysis_info,analysis)

%     accept = 1;

%     analysis = initialize_molecule_positions(analysis_settings,analysis_info,analysis);

%     molecules = make_empty_molecules(analysis.num_mol,analysis.vid_len);
    analysis.molecules = add_molecule_ROI_handles(handles, analysis.molecules, 1);

%     frame = get_frame(handles,i);

    
    % here the initial defocus and ROI are determined
%     analysis = add_basic_molecule_info(analysis,analysis);
%     analysis_info.fitting_params = set_initial_params(analysis_info);    

%     if num_mol>0
%         if handles.analysis_settings.GPU_mode
%             [handles,molecules] = GPU_batch_analysis(handles,analysis.molecules);
%         else
            % continuous mode
            analysis = continuous_analysis(handles,analysis_info,analysis);
%         end        
        

%     else
%         msgbox('no molecules found');
%     end












