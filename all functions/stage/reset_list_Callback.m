function reset_list_Callback(hObject, eventdata, handles)

    
    handles.reaction_list = [];

%     handles.reaction_list(end) = [];
%     handles.reaction_list(1) = [];

%     handles.reaction_list = [handles.reaction_list; handles.reaction_list];

%     handles.reaction_list = [handles.reaction_list; handles.reaction_list(end-1); handles.reaction_list(end)];

%     reaction_list = handles.reaction_list; 

%     save('rxns.mat','reaction_list');

    update_handles(handles.figure1, handles);


