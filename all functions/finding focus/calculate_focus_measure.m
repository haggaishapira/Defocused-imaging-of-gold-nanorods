function focus_measure = calculate_focus_measure(frame,circle_mask,intensity_threshold)

    circle_frame = frame;
    circle_frame(~circle_mask) = 0;
    focus_measure = length(find(circle_frame(:)>intensity_threshold));