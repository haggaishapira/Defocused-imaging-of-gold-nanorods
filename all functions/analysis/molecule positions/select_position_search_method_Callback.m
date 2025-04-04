function select_position_search_method_Callback(hObject, eventdata, handles)

    choices_list = {'search when focused',...
                    'registered positions',...
                    'search when defocused - preset defocus',...
                    'search when defocused - find common defocus',...
                    'search when defocused - find defocus per molecule',...
                    'select positions manually',...
                    };

    curr_choice = find(strcmp(choices_list, handles.curr_position_search_method_setting));

    [new_choice,tf] = my_lst_dlg('ListString',choices_list, 'Name', 'Choose Analysis Mode', 'PromptString', 'Choose Position Search Method',...
                     'InitialValue', curr_choice, 'size_factor', 2.5);

    if ~isempty(new_choice)
        handles.curr_position_search_method_setting = choices_list{new_choice};
    end

    update_handles(handles.figure1,handles);











