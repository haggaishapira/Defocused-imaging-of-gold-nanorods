function handles = initialize_ax_video(handles,dim_vid)

    cla(handles.ax_video);

    min_int = str2num(handles.min_int.String);
    max_int = str2num(handles.max_int.String);
    lims = [min_int max_int];
%     dim_vid = 512;
%     imagesc(zeros(dim_video,dim_video),'Parent',handles.ax_video,lims);
    imagesc(handles.ax_video,zeros(dim_vid,dim_vid));
    if min_int<max_int
        handles.ax_video.CLim = [min_int max_int];
    end
    handles.ax_video.XLim = [0.5 dim_vid+0.5];
    handles.ax_video.YLim = [0.5 dim_vid+0.5];
    colormap(handles.ax_video,gray(50));
    colorbar(handles.ax_video);
