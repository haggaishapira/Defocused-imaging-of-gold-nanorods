function [all_molecules,num_mol] = get_all_molecules(handles)
    

    val = handles.choose_molecule_selection_type.Value;
    molecule_selection_type = handles.choose_molecule_selection_type.String{val};

    all_molecules = [];
    num_mol = 0; 
    if handles.num_files > 0
        analyses = handles.analyses;
        for i=1:handles.num_files
            new_molecules = analyses(i).molecules;
            selection = handles.molecule_selections{i};
            switch molecule_selection_type
                case 'all molecules'
%                     new_molecules = new_molecules
                case 'selected molecules'
                    [new_molecules,num_mol] = get_molecules_from_selection(new_molecules,selection);
                case 'non-selected molecules'
                    all_nums = cell2mat({new_molecules.num});
                    diff = setdiff(all_nums,selection);
                    [new_molecules,num_mol] = get_molecules_from_selection(new_molecules,diff);
            end
            all_molecules = [all_molecules new_molecules];
        end
        num_mol = size(all_molecules,2);
    end






    