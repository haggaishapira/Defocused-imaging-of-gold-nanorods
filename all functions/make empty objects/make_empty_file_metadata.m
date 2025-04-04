function file_metadata = make_empty_file_metadata(id_num)

    file_metadata.id_num = id_num;

    file_metadata.full_name = '';
    file_metadata.pathname = '';
    file_metadata.filename = '';
    file_metadata.extension = '';

    file_metadata.framerate = 0;
    file_metadata.duration = 0;
    file_metadata.vid_len = 0;
    file_metadata.vid_size = [];
    file_metadata.dim_vid = 0;

    file_metadata.binning = 1;
    file_metadata.exposure_time = 0.003;
    file_metadata.laser_power = 180;
    file_metadata.gain = 30;
    file_metadata.bits_per_pixel = 16;

    file_metadata.acquisition_settings = [];
    file_metadata.analysis_settings = [];
    file_metadata.fitting_settings = [];

    file_metadata.first_frames = [];

    file_metadata.tif_object = [];
    file_metadata.rdt_file_descriptor = 0;
    
%     file_metadata.sequence_info = [];




    