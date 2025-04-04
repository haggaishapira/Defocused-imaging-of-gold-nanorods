function apply_area_deltas_Callback(hObject, eventdata, handles)

    handles = apply_area_deltas(handles);

    update_handles(handles.figure1, handles);
