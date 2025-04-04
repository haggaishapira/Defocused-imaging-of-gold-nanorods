function update_ax_video_lims(handles,frame)

    if nargin == 1
        frame = handles.ax_video.Children(end).CData;
    end

    if handles.autoscale.Value
        min_int = min(frame(:));
        max_int = max(frame(:));
        set(handles.ax_video.Children(end),'CData',frame);
        if min_int < max_int
            set(handles.ax_video,'Clim',[min_int max_int]);
        end
        handles.min_int.String = num2str(min_int);
        handles.max_int.String = num2str(max_int);
    else
        min_int = str2double(handles.min_int.String);
        max_int = str2double(handles.max_int.String);
        set(handles.ax_video.Children(end),'CData',frame);           
        if min_int < max_int
            set(handles.ax_video,'Clim',[min_int max_int]);
        end
    end

%     if ~getappdata(0,'acquisition')
%         handles = frame_changed(handles,0,0);
%     end








