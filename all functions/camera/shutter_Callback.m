function shutter_Callback(hObject, eventdata, handles)
    answer = questdlg('Set Shutter Status:','Shutter Status','open','closed','cancel');
    switch answer
        case 'open'
            ret = SetShutter(1,1,1,1);
            CheckWarning(ret);
            if ret == atmcd.DRV_SUCCESS
%                 handles.camera.shutter_text = 'open';
            end
        case 'closed'
            ret = SetShutter(1,2,1,1);
            CheckWarning(ret);
            if ret == atmcd.DRV_SUCCESS
%                 handles.camera.shutter_text = 'closed';
            end
    end
    update_handles(handles.figure1, handles);
