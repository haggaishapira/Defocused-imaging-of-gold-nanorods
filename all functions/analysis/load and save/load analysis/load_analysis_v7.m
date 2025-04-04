function filled_analysis = load_analysis_v7(analysis_filename)

%     load(analysis_filename);
    
    empty_analysis = make_empty_analysis();
    filled_analysis = load_by_overwriting_existing_fields(empty_analysis, analysis_filename);

%     % if rotation type, check molecule field differences
%     if ismember(filled_analysis.analysis_mode, {'rotation',)

        if filled_analysis.num_mol > 0
            new_molecules = [];
            for i=1:filled_analysis.num_mol
                empty_molecule = make_empty_molecule(1,1);
                loaded_molecule = filled_analysis.molecules(i);
                filled_molecule = overwrite_existing_fields(empty_molecule, loaded_molecule, 0);
                check_field_differences(empty_molecule, loaded_molecule, 'molecule', 0);
                new_molecules = [new_molecules filled_molecule];
            end
            filled_analysis.molecules = new_molecules;
        end

%     end
    



