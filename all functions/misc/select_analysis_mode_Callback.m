function select_analysis_mode_Callback(hObject, eventdata, handles)
    
    choices_list = {'rotation','finding area','immobilization','TIRF ensemble','finding focus'};

    curr_choice = find(strcmp(choices_list, handles.analysis_mode_setting));
    
    size_factor = 1;
    [new_choice,tf] = my_lst_dlg('ListString',choices_list, 'Name', 'Choose Analysis Mode', 'PromptString', 'Choose Analysis Mode',...
                     'InitialValue', curr_choice, 'size_factor',size_factor);

    if ~isempty(new_choice)
        handles.analysis_mode_setting = choices_list{new_choice};
    end

    update_handles(handles.figure1,handles);
