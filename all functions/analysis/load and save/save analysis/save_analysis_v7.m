function save_analysis_v7(analysis,full_name,online,custom_name)

%     file_num = handles.file_list.Value;
%     file_metadata = handles.file_metadatas(file_num);
    
%     [pathname, filename, extension] = fileparts(file_metadata.full_name);
    [pathname, filename, extension] = fileparts(full_name);

    path_and_filename = [pathname '\' filename '_analysis'];

    if online
        path_and_filename = [path_and_filename '_online'];
    else
        path_and_filename = [path_and_filename '_offline'];
    end
    
%     analysis = handles.analyses(file_num);

    if custom_name
        uisave('analysis',[path_and_filename '.mat']);
    else
        save([path_and_filename '.mat'],'analysis','-mat');
    end
    
%     msgbox('analysis file saved successfully');
    disp('analysis file saved successfully');


        
        
        
        
        
        
        
        