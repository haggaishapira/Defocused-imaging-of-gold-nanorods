function handles = toggle_ROI_arrow_reference(handles)

    visible = handles.toggle_ROI_arrow_reference.Value;

    handles.ROI_arrow_reference_main.Visible = visible;
    handles.ROI_arrow_reference_right.Visible = visible;
    handles.ROI_arrow_reference_left.Visible = visible;
    

    pause(0.01);

    if visible
        handles.lines_ROI_arrow_reference = ...
            make_lines_array_ROI(handles.ROI_arrow_reference_main,handles.ROI_arrow_reference_right,handles.ROI_arrow_reference_left);
    end

