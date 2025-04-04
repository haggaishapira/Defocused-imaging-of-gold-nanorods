function reactions_and_measure_Callback(hObject, eventdata, handles)


    setappdata(0,'stop_measuring',0);

    handles.choose_molecule_selection_type.Value = 1;
    handles.choose_file_selection_type.Value = 1;

    settings = handles.stage_settings;

    reaction_list = handles.reaction_list;
    num_reactions = length(handles.reaction_list);

    name_step_num = handles.stage_settings.reaction_name_step;

    if isempty(handles.batches)
        msgbox('add batch first');
        return;
    end

    handles.curr_position_search_method_setting = 'registered positions';


    for i=1:num_reactions
            if handles.stop_acquisition.Value || getappdata(0,'stop_measuring')
                disp('abort measurements');
                setappdata(0,'stop_measuring',0);
                return;
            end

        % get sequence
        sequence_info = reaction_list(i);
        command_name = sequence_info.command_names_full_sequence{name_step_num};
        if isempty(command_name)
            command_name = '102';
        end

        % measure reaction
        filename = sprintf('add %s', command_name);
        handles.filename.String = filename;
        pathname_and_filename = [handles.pathname.String '\' filename '_sequence_labview.txt'];
        handles.acquisition_settings.kinetic_cycle_time = 0.3;
        handles.trigger_microfluidics.Value = 1;
        % send sequence to mf
        send_sequence_to_microfluidics(handles,pathname_and_filename,sequence_info);

        handles.analysis_mode_setting = 'rotation';

        fprintf('starting reaction');
        handles = start_acquisition(handles,1);
        disp('finished reaction');

        if handles.stop_acquisition.Value || getappdata(0,'stop_measuring')
            disp('abort measurements');
            return;
        end

        % remember file num of reaction
%         file_num_reaction = handles.file_list.Value;
        file_num_reaction = handles.current_file_num;

%         target_x_str = handles.stage_x_current.String;
%         target_y_str = handles.stage_y_current.String;

        % measure after reaction
        handles.filename.String = sprintf('after %s', command_name);
        handles.acquisition_settings.kinetic_cycle_time = 0.08;
        handles.duration_input.String = num2str(settings.scan_vid_duration);
        handles.trigger_microfluidics.Value = 0;
        handles = measure_existing_areas(handles);    

        if handles.stop_acquisition.Value || getappdata(0,'stop_measuring')
            disp('abort measurements');
            return;
        end

        % go back to area of reaction + 1
%         handles.stage_x_target.String = target_x_str;
%         handles.stage_y_target.String = target_y_str;
        handles.file_list.Value = file_num_reaction;
        handles = delete_all_display_objects(handles,file_num_reaction);    
        handles = select_file(handles,file_num_reaction,1);
        handles = apply_xy_target(handles);
        handles = apply_z_target(handles);

    end

    keep_fresh = 1;
    if keep_fresh
        % send keep fresh signal
        load('keep_fresh_ch2.mat');
        filename = 'keep_fresh';
        handles.filename.String = filename;
        pathname_and_filename = [handles.pathname.String '\' filename '_sequence_labview.txt'];
        handles.trigger_microfluidics.Value = 1;
        send_sequence_to_microfluidics(handles,pathname_and_filename,sequence_info);
    
        % trigger
        response_ok = send_message_and_test_response(handles.microfluidics_connection,'1');
        if response_ok
            disp('triggered microfluidics');
        else
            msgbox('trigger error');
            return;
        end
    end
    setappdata(0,'stop_measuring',0);

    update_handles(handles.figure1, handles);

















    












    
