function count_points_Callback(hObject, eventdata, handles)
    first_frame = str2num(handles.count_points_first_frame.String);
    last_frame = str2num(handles.count_points_last_frame.String);
    frames = handles.video(:,:,first_frame:last_frame);
    len = last_frame-first_frame+1;
    avg_frame = sum(frames,3)/len;
    threshold = str2num(handles.threshold_counts.String);

    do = 1;
    if do == 1
        f1 = figure;
        ax1 = axes(f1);
        imagesc(ax1,avg_frame); 
        colormap(ax1,gray(100));
        colorbar(ax1);

        f2 = figure;
        ax2 = axes(f2);
        imagesc(ax2,avg_frame); 
        colormap(ax2,gray(100));
        colorbar(ax2);

        hold(ax2,'on');

        [sz_y,sz_x] = size(avg_frame);
        pts = [];
        for i=2:sz_y-1
            for j=2:sz_x-1
    %             too_close = false;
    %             for n = 1:size(pts,1)
    %                 yn = pts(n,1);
    %                 xn = pts(n,2);
    %                 d = ((i-yn)^2+(j-xn)^2)^0.5;
    %                 if d<2
    %                     too_close = true;
    %                     break;
    %                 end
    %             end
    %             if too_close
    %                 continue;
    %             end
                val = avg_frame(i,j);
                if val<threshold
                    continue;
                end
                %is local max?
                if val>=avg_frame(i-1,j-1) && val>=avg_frame(i-1,j) && val>=avg_frame(i-1,j+1) && ...
                   val>=avg_frame(i,j-1)                             && val>=avg_frame(i,j+1) && ...
                   val>=avg_frame(i+1,j-1)     && val>=avg_frame(i+1,j)   && val>=avg_frame(i+1,j+1)
                    pts = [pts; i j];
                    plot(ax2,j,i,'.r','linewidth',3);
                    hold(ax2,'on');
                end
            end 
        end
        num_points = size(pts,1);
        handles.count_points_output.String = num2str(num_points);
    else
        f3 = figure;
        ax3 = axes(f3);
        imagesc(ax3,handles.video(:,:,1));
        colormap(ax3,gray(100));
        colorbar(ax3);
        [sz_y,sz_x,len] = size(handles.video);
        nums = [];
        interval = 10;
        for k=1:interval:len
            pts = [];
            frames = handles.video(:,:,k:k+interval-1);
    %         avg_frame = handles.video(:,:,k);
            avg_frame = sum(frames,3) / interval;
    %         imagesc(ax3,avg_frame);
    %         colormap(ax3,gray(100));
    %         hold(ax3,'on');
            for i=2:sz_y-1
                for j=2:sz_x-1
                    val = avg_frame(i,j);
                    if val<threshold
                        continue;
                    end
                    %is local max?
                    if val>=avg_frame(i-1,j-1) && val>=avg_frame(i-1,j) && val>=avg_frame(i-1,j+1) && ...
                       val>=avg_frame(i,j-1)                             && val>=avg_frame(i,j+1) && ...
                       val>=avg_frame(i+1,j-1)     && val>=avg_frame(i+1,j)   && val>=avg_frame(i+1,j+1)
                        pts = [pts; i j];
    %                     plot(ax3,j,i,'.r','linewidth',3);
    %                     hold(ax3,'on');
                    end
                end
            end
    %         pause(0.00001);
    %         disp(size(pts,1));
            nums = [nums size(pts,1)];
        end
        figure
        plot(1:interval:len,nums);
    end
