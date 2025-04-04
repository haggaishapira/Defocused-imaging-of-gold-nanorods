function cooling_Callback(hObject, eventdata, handles)
    answer = questdlg('Cooler Status','Cooler Status','on','off','off');
    if answer
        switch answer
            case 'on'
                ret = CoolerON();
                CheckWarning(ret);
                ret = SetTemperature(-80);
                CheckWarning(ret);
%                 handles.cooling_text.String = 'on';
            case 'off'
                ret = CoolerOFF();
                CheckWarning(ret);         
%                 handles.cooling_text.String = 'off';
        end
    end
    update_handles(handles.figure1, handles);
