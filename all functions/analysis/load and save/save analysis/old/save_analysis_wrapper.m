function save_analysis_wrapper(handles)

    file_num = handles.file_list.Value;
    file = handles.files(file_num);
    
    [pathname, filename, extension] = fileparts(file.full_name);
    final_name = [pathname '\' filename];

    vid_size = [512 512 file.vid_len];
%     vid_size = handles.vid_size;
%     framerate = str2num(handles.framerate.String);
    framerate = file.framerate;
    binning = file.binning;
    total_int = handles.total_int;
    distances = handles.distances;

    [molecules,num_mol] = get_current_molecules(handles);
    if num_mol == 0
        return;
    end

    stage_corr_x = handles.stage_correction_x;
    stage_corr_y = handles.stage_correction_y;

    num_mol_trace = handles.num_mol_trace;
    avg_closest_dist_trace = handles.avg_closest_dist_trace;
    positions_trace = handles.positions_trace;


    save_analysis_v6(final_name,vid_size,framerate,molecules,total_int,binning,stage_corr_x, stage_corr_y, distances);
%     msgbox('analysis saved successfully');





    