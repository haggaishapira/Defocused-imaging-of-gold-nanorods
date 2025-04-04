function export_all_molecules_Callback(hObject, eventdata, handles)


    path = handles.pathname.String;
    filename = handles.filename.String;
    final_pathname = [path '\' filename];

    mol = handles.molecule_list.Value;


    settings = handles.export_settings;
    export_settings_mat = cell2mat(struct2cell(settings));
    if isempty(find(export_settings_mat))
        msgbox('none selected');
        return;
    end

    export_analysis_ROI = settings.export_analysis_ROI;
    export_trace_sm = settings.export_trace_sm;
%     export_trace_ens = settings.export_trace_ens;
    export_polar_hist = settings.export_polar_hist;
    export_linear_hist = settings.export_linear_hist;
    export_fitting = settings.export_fitting;
    export_3d = settings.export_3d;

    trace_sm_type_num = handles.choose_trace_sm.Value;
    trace_sm_type_str = handles.choose_trace_sm.String{trace_sm_type_num};
%     trace_ensemble_type_num = handles.choose_trace_ensemble.Value;
%     trace_ensemble_type_str = handles.choose_trace_ensemble.String{trace_ensemble_type_num};
    hist_polar_type_num = handles.choose_hist_polar.Value;
    hist_polar_type_str = handles.choose_hist_polar.String{hist_polar_type_num};
    hist_linear_type_num = handles.choose_hist_linear.Value;
    hist_linear_type_str = handles.choose_hist_linear.String{hist_linear_type_num};
%     output_number_type_num = handles.choose_output_number.Value;
%     output_number_type_str = handles.choose_output_number.String{output_number_type_num};
   
    analysis = get_current_analysis(handles);
    num_mol = analysis.num_mol;

    for i=1:num_mol

 
        handles.molecule_list.Value = i;
        molecule_list_Callback(hObject, eventdata, handles)
%         pause(0.5);
        full_figure = getframe(handles.figure1);
        full_figure = frame2im(full_figure);
        
        molecule = analysis.molecules(i);    
        mol_extension = ['_' molecule.str];


        if export_analysis_ROI
            frame = getframe(handles.ax_ROI);
            frame = frame2im(frame);
            specific_filename = [final_pathname mol_extension '_ROI.jpg'];
            imwrite(frame,specific_filename,'jpg');
        end
        if export_trace_sm
%             frame = full_figure(250:500,770:1338,:);
            frame = full_figure(250:500,780:1320,:);
            specific_filename = [final_pathname mol_extension '_trace_sm_' trace_sm_type_str '.jpg'];
            imwrite(frame,specific_filename,'jpg');        
        end
        if export_polar_hist
            % get molecule area
%             frame = full_frame(250:500,800:1335,:);
            frame = full_figure(160:500,1530:end-10,:);
            specific_filename = [final_pathname mol_extension '_polar_hist_' hist_polar_type_str '.jpg'];
            imwrite(frame,specific_filename,'jpg');      
        end
        if export_linear_hist
            frame = full_figure(500:750,1500:end-30,:);
            specific_filename = [final_pathname mol_extension '_linear_hist_' hist_linear_type_str '.jpg'];
            imwrite(frame,specific_filename,'jpg');     
        end

    end

    


















