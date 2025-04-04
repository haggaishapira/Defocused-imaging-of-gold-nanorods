function export_image_Callback(hObject, eventdata, handles)
    frame = getframe(handles.ax_video);
    im = frame2im(frame);
%     im = rgb2gray(im);
    path = handles.pathname.String;
    filename = handles.filename.String;
    final_pathname = [path '\' filename '.tiff'];
    imwrite(im,final_pathname,'tiff');  
    disp('image saved');
