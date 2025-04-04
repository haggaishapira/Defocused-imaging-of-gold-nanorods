function export_TIRF_ensemble_trace(handles)

    analysis = get_current_analysis(handles);

    mode = analysis.analysis_mode;
    if ~strcmp(mode,'TIRF ensemble')
        disp('wrong mode');
        return;
    end

    t = analysis.t;
    green = analysis.trace_green;
    red = analysis.trace_red;

    mat = [t' green red];

    [file_metadata,file_num] = get_current_file_metadata(handles);

    pathname = file_metadata.pathname;
    filename = file_metadata.filename;
   

    full_filename = [pathname '\' filename '_traces.txt'];

    writematrix(mat,full_filename,'Delimiter','\t');

    msgbox('time traces saved successfully');







