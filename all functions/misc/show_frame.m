function show_frame(handles,frame)

    dim_vid = size(frame,1);
    if ~isequal(handles.ax_video.XLim,[0.5 dim_vid+0.5])
%         handles.ax_video.XLim = [0.5 dim_vid+0.5];
%         handles.ax_video.YLim = [0.5 dim_vid+0.5];
    end

    update_ax_video_lims(handles,frame);