function save_sequence_info(sequence_info,full_name,online,custom_name)

    [pathname, filename, extension] = fileparts(full_name);

    path_and_filename = [pathname '\' filename '_sequence_info'];

    if online
        path_and_filename = [path_and_filename '_online'];
    else
        path_and_filename = [path_and_filename '_offline'];
    end
    
%     analysis = handles.analyses(file_num);

    if custom_name
        uisave('sequence_info',[path_and_filename '.mat']);
    else
        save([path_and_filename '.mat'],'sequence_info','-mat');
    end
    
%     msgbox('sequence saved successfully');
