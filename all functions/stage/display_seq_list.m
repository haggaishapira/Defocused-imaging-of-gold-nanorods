function display_seq_list(handles)

    len = length(handles.reaction_list);

    if len == 0
        msgbox('empty list');
        return;
    end
    
    name_step_num = handles.stage_settings.reaction_name_step;
%     name_step_num = 1;

    str_list = {};    
    for i=1:len
        sequence_info = handles.reaction_list(i);
        command_name = sequence_info.command_names_full_sequence{name_step_num};
        str_list{i} = command_name;

%         disp(sequence_info);
        disp(sequence_info.command_names_full_sequence);
    end
    msgbox(str_list);










