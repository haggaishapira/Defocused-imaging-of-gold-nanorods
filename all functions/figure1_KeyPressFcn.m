function figure1_KeyPressFcn(hObject, eventdata, handles)

%     disp(eventdata.Key);
   

    key_pressed = eventdata.Key;

    if handles.move_position.Value

        dx = 0;
        dy = 0;
        switch key_pressed
            case 'uparrow'
                dy = -1;
            case 'leftarrow'
                dx = -1;
            case 'downarrow'
                dy = +1;
            case 'rightarrow'
                dx = +1;
            otherwise
                return
        end
        mol = get_disp_mol_index(handles);
        positions = handles.registered_positions;
        positions(mol,:) = positions(mol,:) + [dx dy];
        handles.registered_positions = positions;
    
        ROI_handle = handles.registered_positions_ROI_handles(mol);
        ROI_handle.Position(1:2) = ROI_handle.Position(1:2) + [dx dy];
    
        handles.registered_positions_ROIs(mol,1:2) = handles.registered_positions_ROIs(mol,1:2) + [dx dy];
    end


    if handles.move_stage_manually.Value
        dx = 0;
        dy = 0;

        settings = handles.stage_settings;
        step_size = settings.step_size;
        switch key_pressed
            case 'uparrow'
                dy = step_size;
%                 dx = -1;
            case 'downarrow'
                dy = -step_size;
%                 dx = 1;
            case 'leftarrow'
                dx = -step_size;
%                 dy = 1;
            case 'rightarrow'
                dx = +step_size;
%                 dy = -1;
            otherwise
                return
        end
        handles = move_stage_delta(handles,dx,dy);

    end

    update_handles(handles.figure1, handles);

    





