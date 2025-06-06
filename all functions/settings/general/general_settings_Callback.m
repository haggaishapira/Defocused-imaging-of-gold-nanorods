function general_settings_Callback(hObject, eventdata, handles)

    current_settings = handles.general_settings;
    field_names = fieldnames(current_settings);
    prompt = field_names;
    title = 'general Settings';
    dimensions = [1 40];
    default_inputs = struct2cell(current_settings);
    for i=1:length(default_inputs)
       cell = default_inputs(i);
       default_inputs(i) = {num2str(cell{1})}; 
    end
    resizable_horizontally = 'on';
    num_col = 1;
    warning ('off','all');
    txt_size = 16;
    answer = inputdlgcol(prompt,title,dimensions,default_inputs,resizable_horizontally,num_col,txt_size);
    warning ('on','all');
    if ~isequal(answer,{})
        for i=1:length(answer)
            answer{i} = str2num(answer{i});
        end
        handles.general_settings = cell2struct(answer, field_names, 1);
    end
    update_handles(handles.figure1, handles);





