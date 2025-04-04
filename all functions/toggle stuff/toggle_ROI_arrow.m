function handles = toggle_ROI_arrow(handles)

    visible = handles.toggle_ROI_arrow.Value;

    handles.ROI_arrow_main.Visible = visible;
    handles.ROI_arrow_left.Visible = visible;
    handles.ROI_arrow_right.Visible = visible;

%     handles.ROI_arrow_initial_main.Visible = visible;
%     handles.ROI_arrow_initial_left.Visible = visible;
%     handles.ROI_arrow_initial_right.Visible = visible;

    pause(0.01);

    if visible
        handles.lines_ROI_arrow = make_lines_array_ROI(handles.ROI_arrow_main,handles.ROI_arrow_right,handles.ROI_arrow_left);
    end

