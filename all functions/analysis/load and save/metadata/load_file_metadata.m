function filled_file_metadata = load_file_metadata(empty_file_metadata)

    [pathname, filename, extension] = fileparts(empty_file_metadata.full_name);
    metadata_filename = [pathname '\' filename '_metadata.mat'];

    filled_file_metadata = load_by_overwriting_existing_fields(empty_file_metadata, metadata_filename);