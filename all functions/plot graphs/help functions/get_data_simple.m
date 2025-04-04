function data = get_data_simple(struct, field)
    
    data = [];
    if ~isempty(struct)
        for i=1:length(struct)
            if size(struct(i).(field),1)>1
                struct(i).(field) = (struct(i).(field))';
            end
        end
        data = cell2mat({struct.(field)});
    end
