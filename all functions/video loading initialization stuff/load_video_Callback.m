function load_video_Callback(hObject, eventdata, handles)
    
    clc

    % for solving temporary synthetic acquisition bug
    if getappdata(0,'acquisition')
        setappdata(0,'acquisition',0);
    end
    % delete previous molecules arrows and text - dont overload the system with these
    % objects. but keep the molecule data structure of course.

    % save the file id in order to close it when closing the program
%     default_path = [handles.pathname.String '/*.tif'];
%     default_path = {[handles.pathname.String '*.rdt']; [handles.pathname.String '*.tif']};
%     default_path = {'*.rdt'; '*.tif'};
%     default_path = [handles.pathname.String '/*.*'];
    path = handles.pathname.String;
%     default_path = {[ '*.rdt']; [handles.pathname.String '*.tif']};  

%     default_path = fullfile(path,'*.rdt;*.tif;*.fits');
    default_path = fullfile(path,'*.rdt;');
%     default_path = fullfile(path,'*.rdt;*.tif;*.BTF');
    
    [files,pathname] = uigetfile(default_path, 'select video file','MultiSelect','on');
    if ~iscell(files) & ~files
        return;
    end

%     handles = delete_all_display_objects(handles);

    load_and_analyze = handles.load_and_analyze.Value;



    if iscell(files)
        reverse = 0;
        if reverse
            files = fliplr(files);
        end
        for i=1:length(files)    
            handles = load_video(handles,files{i},pathname);
            if load_and_analyze
                handles = analyze(handles);
            end
        end
    else
        file = files;
        handles = load_video(handles,file,pathname);
        if load_and_analyze
            handles = analyze(handles);
        end
    end

    handles = apply_filters(handles);


    update_handles(hObject,handles);








    
