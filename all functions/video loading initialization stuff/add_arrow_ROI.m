function [arrow_main,arrow_right,arrow_left] = add_arrow_ROI(handles)


    visible = handles.toggle_ROI_arrow.Value;

    XLim = handles.ax_ROI.XLim;
    YLim = handles.ax_ROI.YLim;

    ROI = [1 1 29 29];

    color = 'red';

    pos = handles.ax_ROI.Position;
    phi = 0;
    [x_main,y_main,x_right,y_right,x_left,y_left] = get_arrow_coordinates_ROI(ROI,phi,pos,XLim,YLim);
    hold(handles.ax_video,'on');
    arrow_main = line(handles.ax_ROI,x_main,y_main,'Color',color,'LineWidth',3,'Visible',visible);
    hold(handles.ax_video,'on');
    arrow_right = line(handles.ax_ROI,x_right,y_right,'Color',color,'LineWidth',3,'Visible',visible);
    hold(handles.ax_video,'on');
    arrow_left = line(handles.ax_ROI,x_left,y_left,'Color',color,'LineWidth',3,'Visible',visible);

    pause(0.01);