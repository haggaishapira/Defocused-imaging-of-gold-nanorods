function analysis = load_analysis_wrapper(handles,file)
    [pathname, filename, extension] = fileparts(file.full_name);
    try
        analysis = [];
        choose_analysis = handles.choose_analysis.Value;
        if choose_analysis
%             default_path = [handles.pathname.String '/*.*'];
            default_filename = [pathname '\' filename '_analysis*.mat'];
            [analysis_filename_with_ext,pathname] = uigetfile(default_filename, 'select analysis file');
            if ~analysis_filename_with_ext
                return;
            end
            final_filename = [pathname analysis_filename_with_ext];
        else
            % try to get offline analysis, then online analysis
%             [pathname, filename, extension] = fileparts(file.full_name);
            filename_default_offline = [pathname '\' filename '_analysis_offline' '.mat'];
            if isfile(filename_default_offline)
                disp('found offline analysis file. loading it.');
                final_filename = filename_default_offline;
            else
                filename_default_online = [pathname '\' filename '_analysis_online' '.mat'];
                if isfile(filename_default_online)
                    disp('found online analysis file. loading it.');
                    final_filename = filename_default_online;
                else
                    final_filename = '';
                end
            end
        end
        analysis = load_analysis_v7(final_filename);
        disp('loaded .mat analysis file');
        success = 1;
    catch e
        disp(e);
        msgbox('error in loading analysis file');
        success = 0;
    end
    
    if ~success
        analysis = make_empty_analysis();
    end










