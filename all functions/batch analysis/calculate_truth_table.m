function truth_table = calculate_truth_table(handles)

    truth_table = [];

    num_batches = size(handles.batches,1);
    if num_batches == 0
        return;
    end


    num_mol_all = 0;
    % go over batch 1
    file_metadatas = handles.file_metadatas;
    all_id_nums = cell2mat({file_metadatas.id_num});
    
    batch = handles.batches(1);
%     num_files_in_batch = length(batch.id_nums);

    for i=1:length(batch.id_nums)
        id = batch.id_nums(i);
        file_num = file_num_from_id(handles,id);
        num_mol = handles.analyses(file_num).num_mol;
        num_mol_all = num_mol_all + num_mol;
    end

    % get all mus
    mu_table = zeros(num_mol_all,num_batches);
    stuck_table = zeros(num_mol_all,num_batches);

    for i=1:num_batches
        batch = handles.batches(i);
        mol_ind = 1;
        for j=1:length(batch.id_nums)
            id = batch.id_nums(j);
            file_num = file_num_from_id(handles,id);
            analysis = handles.analyses(file_num);
            molecules = analysis.molecules;
            num_mol = analysis.num_mol;
            mus_curr_file = cell2mat({molecules.phi_dist_mu});
            stucks_curr_file = cell2mat({molecules.stuck});
            mu_table(mol_ind:mol_ind + num_mol - 1,i) = mus_curr_file';
            stuck_table(mol_ind:mol_ind + num_mol - 1,i) = stucks_curr_file';
            mol_ind = mol_ind + num_mol;
        end
    end

    mu_table = mod(mu_table,180);
    angles = cell2mat({handles.batches.angle});
    
    filtered_molecules = zeros(num_mol_all,1);

    
    threshold = 30;

    for i=1:num_mol_all
        if i == 60
            1;
        end
        found = 0;
        for j=1:num_batches
            if found
                break;
            end
            for k=1:num_batches
                if found
                    break;
                end
                if j == k
                    continue;
                end
                if ~stuck_table(i,j) || ~stuck_table(i,k)
                    continue;
                end
                nominal_delta = mod(angles(k) - angles(j),180);
                measured_delta = mod(mu_table(i,k) - mu_table(i,j),180);
                if abs(nominal_delta - measured_delta) < threshold
                    filtered_molecules(i) = 1;
                    found = 1;
                    break;
                end
            end
        end
    end


    % for filtered molecules, create truth table. use selected batch as
    % reference angle
    truth_table = zeros(num_mol_all,num_batches);
    reference_batch = handles.batch_list.Value;
    reference_angle = angles(reference_batch);

    for i=1:num_mol_all
        if ~filtered_molecules(i)
            continue;
        end
        mus = mu_table(i,:) - mu_table(i,reference_batch) + reference_angle;
        truth_table(i,:) = mod(mus - angles,180) < threshold;
    end







