function export_data_Callback(hObject, eventdata, handles)

    settings = handles.export_settings;



    export_trace_sm = settings.export_trace_sm;
    export_trace_ens = settings.export_trace_ens;
    export_hist_polar = settings.export_polar_hist;
    export_hist_linear = settings.export_linear_hist;

    if ~export_trace_sm && export_trace_ens && export_hist_polar && export_hist_linear
        return;
    end

    file_metadata = get_current_file_metadata(handles);
    path_name = file_metadata.pathname;
    filename = file_metadata.filename;
%     combined = [path_name '\' filename];
%     export_path = uigetdir(path_name,'choose folder');
    export_path = path_name;

    analysis = get_current_analysis(handles);
    if handles.num_files == 0 || analysis.empty
        return;
    end

    trace_sm_type_num = handles.choose_trace_sm.Value;
    trace_sm_type_str = handles.choose_trace_sm.String{trace_sm_type_num};
    trace_ens = handles.choose_trace_ensemble.Value;
    trace_ens_type_str = handles.choose_trace_ensemble.String{trace_ens};
    hist_polar_type_num = handles.choose_hist_polar.Value;
    hist_polar_type_str = handles.choose_hist_polar.String{hist_polar_type_num};
    hist_linear_type_num = handles.choose_hist_linear.Value;
    hist_linear_type_str = handles.choose_hist_linear.String{hist_linear_type_num};

%     output_number_type_num = handles.choose_output_number.Value;
%     output_number_type_str = handles.choose_output_number.String{output_number_type_num};
    
    
    num_mol = analysis.num_mol;
    t = analysis.t;
    vid_len = analysis.vid_len;
    if size(t,2) > 1
        t = t';
    end

    if export_trace_sm && num_mol>0
        curr_mol_num = handles.curr_mol_num;
        molecule = analysis.molecules(curr_mol_num);
        real_num = molecule.num;
        str_export = [export_path '\' filename '_' trace_sm_type_str ' - mol' num2str(real_num) '.xlsx'];
        
        all_plots = get(handles.ax_trace_sm,'Children');
        total_num_plots = length(all_plots);
        for i=1:total_num_plots
            p = all_plots(i);
            cl = class(p);
            if strcmp(cl,'matlab.graphics.chart.primitive.Line')
                t = p.XData;
                trace = p.YData;
            end
        end

%         t = handles.ax_trace_sm.Children(end).XData;
%         trace = handles.ax_trace_sm.Children(end).YData;

        matrix = [t' trace'];

        writematrix(matrix,str_export);
    end


    if export_trace_ens
        str_export = [export_path '\' filename '_' trace_ens_type_str '.xlsx'];
%         trace = get_sm_data(molecule,trace_sm_type_str,1,vid_len);
%         trace = t;

%         t = handles.ax_trace_ensemble.Children(end).XData;
%         trace = handles.plot_info.plot_ensebmlehandles.ax_trace_ensemble.Children(end).YData;
        t = handles.plot_info.ens_plot.XData;
        trace = handles.plot_info.ens_plot.YData;
        if ~isempty(handles.plot_info.ens_fitting)
            fitting = handles.plot_info.ens_fitting(1);
            fitting = fitting.YData;
        end

        matrix = [t' trace'];
%         if ~isempty(fitting)
%             matrix = [matrix fitting];
%         end
    

        if exist(str_export, 'file')==2
            delete(str_export);
            msgbox('deleted file with this name first');
        end
            
        writematrix(matrix,str_export);
    end

    if export_hist_linear
        str_export = [export_path '\' filename '_linear_hist_' hist_linear_type_str '.xlsx'];
        data = handles.ax_hist_linear.Children.Data;
%         edges = handles.ax_hist_linear.Children.BinEdges;
%         bins = (edges(1:end-1) + edges(2:end))/2;
%         counts = handles.ax_hist_linear.Children.Values;
% 
%         matrix = [bins' counts'];  
        matrix = data';

        if exist(str_export, 'file')==2
            delete(str_export);
            msgbox('deleted file with this name first');
        end
            
        writematrix(matrix,str_export);
    end


    if export_hist_polar
        str_export = [export_path '\' filename '_polar_hist_' hist_polar_type_str '.xlsx'];

        edges = handles.ax_hist_polar.Children.BinEdges;
        bins = (edges(1:end-1) + edges(2:end))/2;
        counts = handles.ax_hist_polar.Children.Values;

        matrix = [bins' counts'];  

        if exist(str_export, 'file')==2
            delete(str_export);
            msgbox('deleted file with this name first');
        end
            
        writematrix(matrix,str_export);
    end


%     disp('export finished');
    msgbox('export data finished');

    update_handles(handles.figure1, handles);








