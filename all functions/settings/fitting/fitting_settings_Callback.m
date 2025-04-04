function fitting_settings_Callback(hObject, eventdata, handles)
    
    current_settings = handles.pattern_fitting_settings;
    field_names = fieldnames(current_settings);
    prompt = field_names;
    title = 'Fitting Settings';
    dimensions = [1 20];
    default_inputs = struct2cell(current_settings);
    for i=1:length(default_inputs)
       cell = default_inputs(i);
       default_inputs(i) = {num2str(cell{1})}; 
    end
    resizable_horizontally = 'on';
    num_col = 3;
    warning ('off','all');
    txt_size = 18;
    answer = inputdlgcol(prompt,title,dimensions,default_inputs,resizable_horizontally,num_col,txt_size);
%     answer = inputdlgcol(prompt,title,dimensions,default_inputs,resizable_horizontally,num_col);
%     answer = inputdlg(prompt,title,dimensions,default_inputs,resizable_horizontally);
    warning ('on','all');
    if ~isequal(answer,{})
        for i=1:length(default_inputs)
            answer{i} = str2num(answer{i});
        end
        handles.pattern_fitting_settings = cell2struct(answer, field_names, 1);
        handles = generate_all_patterns(handles);
        nn = handles.pattern_fitting_settings.nn;
        nn_array = handles.nn_array;
        [~,defocus_ind] = ismember(nn,nn_array); 
        handles.current_defocus_ind = defocus_ind;
        update_handles(handles.figure1, handles);
    end







    