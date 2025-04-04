function frames = get_molecule_frames(handles,analysis,molecule,frame_selection_type,curr_frame,first,last)
    
%     [first,last] = get_timeframe(handles,analysis);

    frames = first:last;
%     all_frames = setdiff

    switch frame_selection_type
        case 'current frame'
            frames = intersect(frames,curr_frame);
        case 'all frames'
%             frames = frames;
        case 'on frames'
            frames = intersect(frames,molecule.on_frames);
        case 'off frames'
            frames = setdiff(frames,molecule.on_frames);
    end

    