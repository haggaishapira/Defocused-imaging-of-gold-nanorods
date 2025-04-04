function add_seq_to_list_Callback(hObject, eventdata, handles)
    
    handles = load_sequence_info_from_mf(handles);
    sequence_info = handles.current_sequence_info;

    handles.reaction_list = [handles.reaction_list; sequence_info];
%     handles.reaction_list = [sequence_info; handles.reaction_list];

    display_seq_list(handles);

    update_handles(handles.figure1, handles);
