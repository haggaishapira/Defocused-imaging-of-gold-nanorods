function stage_settings_Callback_Callback(hObject, eventdata, handles)

    stage_settings = handles.stage_settings;
    field_names = fieldnames(stage_settings);
    prompt = field_names;
    title = 'stage Settings';
    dimensions = [1 40];
    default_inputs = struct2cell(stage_settings);
    for i=1:length(default_inputs)
       cell = default_inputs(i);
       default_inputs(i) = {num2str(cell{1})}; 
    end
    resizable_horizontally = 'on';
    num_col = 2;
    warning ('off','all');
    txt_size = 12;
    answer = inputdlgcol(prompt,title,dimensions,default_inputs,resizable_horizontally,num_col,txt_size);
    warning ('on','all');
    if ~isequal(answer,{})
        for i=1:length(answer)
            answer{i} = str2num(answer{i});
        end
        handles.stage_settings = cell2struct(answer, field_names, 1);
    end



    update_handles(handles.figure1, handles);





