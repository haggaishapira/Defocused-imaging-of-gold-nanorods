function [all_molecules,num_mol] = get_molecules_from_files(handles,file_selection,use_selected_molecules)
    all_molecules = [];
    num_mol = 0; 
    if handles.num_files > 0
        analyses = handles.analyses;
        num_files_selected = length(file_selection);
        for i=1:num_files_selected
            file_num = file_selection(i);
            new_molecules = analyses(file_num).molecules;
            if use_selected_molecules
                molecule_selection = handles.molecule_selections{file_num};
                new_molecules = get_molecules_from_selection(new_molecules,molecule_selection);
                %%% temp code fix
                for j=1:length(new_molecules)
                    new_molecules(j).t = analyses(file_num).t;
                end
                %%% temp code
            end
            all_molecules = [all_molecules new_molecules];
        end
        num_mol = size(all_molecules,2);
    end