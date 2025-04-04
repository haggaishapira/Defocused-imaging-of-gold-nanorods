function sequence_info = load_sequence_info_wrapper(handles,file_metadata)
    
    try
        sequence_info = make_empty_sequence_info();
        choose_sequence = 0;
        if choose_sequence
            default_path = [handles.pathname.String '/*.*'];
            [sequence_filename_with_ext,pathname] = uigetfile(default_path, 'select sequence file');
            if ~sequence_filename_with_ext
                return;
            end
            final_filename = [pathname sequence_filename_with_ext];
        else
            % try to get offline sequence, then online sequence
            [pathname, filename, extension] = fileparts(file_metadata.full_name);
            filename_default_offline = [pathname '\' filename '_sequence_info_offline' '.mat'];
            if isfile(filename_default_offline)
                disp('found offline sequence file. loading it.');
                final_filename = filename_default_offline;
            else
                filename_default_online = [pathname '\' filename '_sequence_info_online' '.mat'];
                if isfile(filename_default_online)
                    disp('found online sequence file. loading it.');
                    final_filename = filename_default_online;
                else
                    final_filename = '';
                end
            end
        end
        if ~isempty(final_filename)
            sequence_info = load_sequence_info(final_filename);
        else
            disp('no sequence available');
            return;
        end
        disp('loaded .mat sequence file');
        success = 1;
    catch e
        disp(e);
%         msgbox('error in loading sequence file');
%         msgbox('no sequence file found');
        success = 0;
    end
    
    if ~success
        sequence_info = make_empty_sequence_info();
    end










