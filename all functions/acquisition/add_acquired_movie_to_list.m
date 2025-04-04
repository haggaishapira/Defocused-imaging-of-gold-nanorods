function [handles,file_metadata,new_file_num] = add_acquired_movie_to_list(handles,acq,file_metadata)

%     handles.extension = '.fits';
%     handles.extension = '.tif';
    handles.extension = '.rdt';

    handles.num_files = handles.num_files + 1;
    new_file_num = handles.num_files;
    handles.current_file_num = new_file_num;

    file_metadata.framerate = acq.framerate;
    file_metadata.duration = acq.duration;
    file_metadata.vid_len = acq.vid_len;
    file_metadata.dim_vid = acq.dim_vid;
    file_metadata.vid_size = [acq.dim_vid acq.dim_vid acq.vid_len];

    file_metadata.binning = acq.binning;
    file_metadata.bits_per_pixel = acq.bits_per_pixel;
    file_metadata.gain = acq.gain;
    file_metadata.exposure_time = acq.exposure_time;

%     full_name = handles.filename_fits;
    full_name = acq.filename_resave;
    [path, filename, extension] = fileparts(full_name);

    file_metadata.pathname = path;
    file_metadata.filename = filename;
    file_metadata.extension = extension;
    file_metadata.full_name = full_name;

%     file.tif_object = acq.resave_tif_object;
%     file.rdt_file_descriptor = acq.resave_file_descriptor;
    
    file_metadata.acquisition_settings = handles.acquisition_settings;
    file_metadata.analysis_settings = handles.analysis_settings;
    file_metadata.fitting_settings = handles.fitting_settings;

    handles.file_metadatas = [handles.file_metadatas; file_metadata];

    handles.file_list.Value = new_file_num;
    handles.file_list.String{new_file_num} = file_metadata.filename;
    handles.file_list.Max = handles.num_files;


%     handles.current_filename = handles.filename_fits;
%     handles.current_filename = handles.filename_read_tif;
    
    








