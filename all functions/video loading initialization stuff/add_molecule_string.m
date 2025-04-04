function molecules = add_molecule_string(molecules)
    num_mol = size(molecules,2);
    for i=1:num_mol
        molecules(i).str = sprintf('molecule %d',i);
    end