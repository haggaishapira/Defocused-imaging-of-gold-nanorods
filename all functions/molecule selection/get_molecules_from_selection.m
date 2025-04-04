function [selected_molecules,num_mol] = get_molecules_from_selection(molecules,selection)
   
    selected_molecules = [];
    for j=1:size(molecules,2)
        curr_num = molecules(j).num;
        if ismember(curr_num,selection)
            selected_molecules = [selected_molecules molecules(j)];
        end
    end
    num_mol = size(selected_molecules,2);