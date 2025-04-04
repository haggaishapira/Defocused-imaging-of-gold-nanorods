function handles = update_molecule_text_num_colors(handles)
    
    [molecules,num_mol] = get_current_molecules(handles);
    if num_mol == 0
        return;
    end

%     clc

    % follow previous molecule by real num, because of possible molecular sorting
    prev_real_num = handles.curr_mol_real_num;
%     disp(prev_real_num);
    for i=1:num_mol
        molecule = molecules(i);
        if molecule.num == prev_real_num
            molecule.text_num.Color = [1 0 0];
            break;
        end
    end

%     new_mol_num = handles.molecule_list.Value;
%     disp_mol_index = get_mol_index_from_non_selected(handles);
    disp_mol_index = get_disp_mol_index(handles);

%     disp(disp_mol_index);

    new_molecule = molecules(disp_mol_index);
    new_molecule.text_num.Color = [1 1 0];

    handles.curr_mol_num = disp_mol_index;
    handles.curr_mol_real_num = new_molecule.num;

%     disp(handles.curr_mol_real_num);




