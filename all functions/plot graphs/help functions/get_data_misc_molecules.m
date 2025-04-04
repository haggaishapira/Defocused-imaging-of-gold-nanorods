function all_data = get_data_misc_molecules(molecules,num_mol,field,frames,subtract_FH12_pos)
  
    if nargin<5
        subtract_FH12_pos = 0;
    end
%     subtract_FH12_pos = 0;
    total_len_data = 0;
    for i=1:num_mol
        mol_frames = frames{i};
        total_len_data = total_len_data + length(mol_frames);
    end
    
    all_data = zeros(total_len_data,1);
    
    ind_data = 1;
    for i=1:num_mol
        mol_frames = frames{i};
        len_mol_data = length(mol_frames);
        mol_data = molecules(i).(field)(mol_frames);
        if subtract_FH12_pos
            FH12_pos = molecules(i).FH12_position;
            mol_data = mol_data - FH12_pos;
        end
        all_data(ind_data:ind_data + len_mol_data - 1) = mol_data;
        ind_data = ind_data + len_mol_data;
    end
    








    