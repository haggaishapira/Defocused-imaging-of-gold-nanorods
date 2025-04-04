function toggle_arrows_Callback(hObject, eventdata, handles)

    handles = toggle_arrows(handles);

    pause(0.01);

    update_handles(handles.figure1, handles);
