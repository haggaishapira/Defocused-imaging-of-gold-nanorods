function measure_existing_areas_Callback(hObject, eventdata, handles)


    setappdata(0,'stop_measuring',0);

    handles = measure_existing_areas(handles);

    if getappdata(0,'stop_measuring')
       setappdata(0,'stop_measuring',0);
    end

    update_handles(handles.figure1, handles);










