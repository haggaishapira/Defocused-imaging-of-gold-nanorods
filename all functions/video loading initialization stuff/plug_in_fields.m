function filled_molecules = plug_in_fields(empty_molecules,new_molecules,num_mol)

    filled_molecules = [];
    for i=1:num_mol
        empty_molecule = empty_molecules(i);
        new_molecule = new_molecules(i);
        field_names = fieldnames(new_molecule);
        num_fields = length(field_names);
        for j=1:num_fields
            field = field_names{j};
            empty_molecule.(field) = new_molecule.(field);
        end
        filled_molecules = [filled_molecules empty_molecule];
    end

