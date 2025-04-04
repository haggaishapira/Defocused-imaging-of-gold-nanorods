function skip_less_Callback(hObject, eventdata, handles)


    skip = str2num(handles.skip_frames.String);
    if skip == 1
        return;
    end
    skip = round(skip / 10);
    handles.skip_frames.String = num2str(skip);
    handles.slider_frames.SliderStep = (handles.slider_frames.SliderStep) / 10;
    update_handles(handles.figure1,handles);
