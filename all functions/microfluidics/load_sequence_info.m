function sequence_info = load_sequence_info(sequence_info_filename)

%    sequence_info = load(sequence_info_filename);

    sequence_info = make_empty_sequence_info();

    sequence_info = load_by_overwriting_existing_fields(sequence_info,sequence_info_filename);

%     sequence_info.time_intervals = sequence_info.time_intervals * 1.0005;