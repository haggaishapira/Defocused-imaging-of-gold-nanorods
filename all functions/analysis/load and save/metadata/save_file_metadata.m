function save_file_metadata(file_metadata)
    
    [pathname, filename, extension] = fileparts(file_metadata.full_name);
    path_and_filename = [pathname '\' filename '_metadata'];

    save([path_and_filename '.mat'],'file_metadata','-mat');
    
%     msgbox('metadata saved successfully');
