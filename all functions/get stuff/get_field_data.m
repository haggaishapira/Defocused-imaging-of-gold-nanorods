function data = get_field_data(keyword_cell,field_name)
    data = [];
    for i=1:size(keyword_cell,1)
        if strcmp(keyword_cell(i,1),field_name)
            data = keyword_cell{i,2};
            break;
        end
    end
