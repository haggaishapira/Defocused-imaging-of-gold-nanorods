function play_Callback(hObject, eventdata, handles)
    setappdata(0,'stop',0);

    setappdata(0,'playing',1);

    current_frame = round(handles.slider_frames.Value);   
    tic
    
%     path = handles.pathname.String;
%     filename = handles.filename.String;
%     final_pathname = [path filename 'asasdd'];
%     writerObj = VideoWriter(final_pathname, 'Uncompressed AVI');
%     open(writerObj);
    analysis = get_current_analysis(handles);

    while 1
       if getappdata(0,'stop') == 1
           break;
       end
       handles.slider_frames.Value = current_frame;
       handles = frame_changed(handles,0,0);
%         handles = plot_graphs(handles,0,0,analysis);

       current_frame = current_frame + 1;
       if current_frame>handles.vid_len
           current_frame = 1;
       end
       t = toc;
       framerate = str2num(handles.framerate.String);
       ms_per_frame_corr = 1/framerate - 0.005;
       if t<ms_per_frame_corr
%            pause(ms_per_frame_corr-t);
%            pause(0.001);
       else
%            pause(0.001);
       end
%        toc
       drawnow
       tic
%        frame = getframe(handles.figure1);
%        cdata = frame.cdata;
%        cdata = cdata(184:944,55:950,:);
%        writeVideo(writerObj, cdata);
    end
%     close(writerObj);
    setappdata(0,'playing',0);

    update_handles(handles.figure1, handles);



