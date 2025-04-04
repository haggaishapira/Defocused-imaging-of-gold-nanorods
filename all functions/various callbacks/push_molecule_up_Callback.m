function push_molecule_up_Callback(hObject, eventdata, handles)

    [molecules,num_mol] = get_current_molecules(handles);
    if num_mol>0
        mol_num = handles.molecule_list.Value;
        if mol_num>1
            % update list
            temp_str = handles.molecule_list.String{mol_num-1};
            handles.molecule_list.String{mol_num-1} = handles.molecule_list.String{mol_num};
            handles.molecule_list.String{mol_num} = temp_str;
            handles.molecule_list.Value = mol_num-1;

            % update struct
            temp_mol = molecules(mol_num-1);
            molecules(mol_num-1) = molecules(mol_num);
            molecules(mol_num) = temp_mol;
            handles.curr_mol_num = handles.curr_mol_num - 1;

            handles = set_molecules(handles,handles.current_file_num,molecules);
        end
    end
    update_handles(hObject,handles);