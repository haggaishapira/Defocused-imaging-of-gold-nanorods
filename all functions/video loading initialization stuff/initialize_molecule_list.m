function handles = initialize_molecule_list(handles, molecules)

    handles.curr_mol_num = 1;

    if isempty(molecules)
        return;
    end
    all_mol_nums = cell2mat({molecules.num});
    molecule_selection = get_current_molecule_selection(handles);
%     molecule_selection = [];
    non_selected = setdiff(all_mol_nums,molecule_selection);

    handles.molecule_list.String = {};
    handles.selected_molecules_list.String = {};

    num_mol = size(molecules,2);


    % create lists
    ind_first = 1;
    ind_second = 1;
    for i=1:num_mol
        num = molecules(i).num;
        if ~ismember(num,molecule_selection)
            % add to first list - unselected
            handles.molecule_list.String{ind_first} = molecules(i).str;
            ind_first = ind_first + 1;
        else
            % add to second list - selected
            handles.selected_molecules_list.String{ind_second} = molecules(i).str;
            ind_second = ind_second + 1;
        end
    end


    % figure out what molecule to select
    curr_real_num = handles.curr_mol_real_num;

    % first check where curr number is if at all
    ind = find(molecule_selection == curr_real_num);
    if ind
        handles.selected_molecules_list.Value = ind;
        handles.molecule_list.Value = [];
    else
        % see if it is in non-selected
        ind = find(non_selected == curr_real_num);
        if ind
            handles.molecule_list.Value = ind;
            handles.selected_molecules_list.Value = [];
        else
            % didnt find the molecule, so just set to first in list
            if ~isempty(molecule_selection)
                handles.selected_molecules_list.Value = 1;
                handles.molecule_list.Value = [];
            else
                handles.selected_molecules_list.Value = [];
                handles.molecule_list.Value = 1;
            end
        end
    end







    


