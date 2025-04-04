function analysis = trim_analysis_vid_len(analysis,cropped_len)
    
    field_names = fieldnames(analysis);
    original_vid_len = analysis.vid_len;
    
    num_fields = length(field_names);
    for i=num_fields
        field_name = field_names{i};
        field = analysis.(field_name);
        if length(field) == original_vid_len
            trimmed_field = field(1:cropped_len);
            analysis.(field_name) = trimmed_field;
        end
    end

    % molecules
    num_mol = analysis.num_mol



