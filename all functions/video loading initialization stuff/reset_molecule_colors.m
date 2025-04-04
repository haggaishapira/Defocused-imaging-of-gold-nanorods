function reset_molecule_colors(molecules,num_mol)

    for i=1:num_mol
        molecules(i).text_num.Color = [1 0 0];
    end