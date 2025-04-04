function choose_path_Callback(hObject, eventdata, handles)
    default_path = handles.pathname.String;
    pathname = uigetdir (default_path, 'select folder');
    handles.pathname.String = pathname;
