function [analysis_info,ROIs_to_keep, lst_sqs_to_keep,defocuses] = find_ROIs_uncommon_defocus(handles)

    analysis_info = handles.analysis_info;
    analysis_settings = handles.analysis_settings;

    num_mol = analysis_settings.num_molecules;
    avg_frame = analysis_info.avg_frame;    

    [h_frame,w_frame,~]=size(avg_frame);
    num_defocuses = get_num_defocuses(handles);
    
    all_ROIs = [];
    all_lst_sqs = [];
%     rings_by_grade_with_tags

    wait_bar = waitbar(0,sprintf('defocus %d/%d', 0,num_defocuses));    
    for i=1:num_defocuses
        ROI_dim = analysis_info.ROI_dim_array(i);
        current_patterns = get_patterns(handles,i,1,1);
        result_matrix = zeros(h_frame-ROI_dim+1,w_frame-ROI_dim+1);
        sorted_inds = sort_positions_by_ring_fitting(handles,avg_frame, ROI_dim, analysis_info.original_mask, result_matrix);
        [ROIs,lst_sqs,num_found] = choose_molecules_from_best_rings(analysis_info,analysis_settings,sorted_inds, ROI_dim, result_matrix, current_patterns);
        all_ROIs = [all_ROIs; ROIs];
        all_lst_sqs = [all_lst_sqs; lst_sqs'];
%         disp(num_found);
        waitbar(i/num_defocuses,wait_bar,sprintf('defocus %d/%d', i,num_defocuses));
    end
    close(wait_bar);

    num_found = size(all_ROIs,1);
    num_mol = min(num_mol,num_found);

    T = table(all_ROIs,all_lst_sqs);
    T = sortrows(T,'all_lst_sqs');
    all_ROIs = T.all_ROIs;
    all_lst_sqs = T.all_lst_sqs;

    % now iterate and make sure molecules are not too close
    if num_found>0
        ROIs_to_keep = all_ROIs(1,:);
        lst_sqs_to_keep = all_lst_sqs(1);
        num_added_mol = 1;
        for i=2:num_found
            ROI = all_ROIs(i,:);
            if ~molecule_too_close(ROI,ROIs_to_keep,num_added_mol)
                ROIs_to_keep = [ROIs_to_keep; all_ROIs(i,:)];
                lst_sqs_to_keep = [lst_sqs_to_keep; all_lst_sqs(i)];
                num_added_mol = num_added_mol + 1;
            end
%             if num_added_mol == num_mol
%                 break;
%             end
        end
    end

    defocuses = zeros(num_added_mol,1);
    defocus_array = get_defocus_array(handles);
    for i=1:num_added_mol
        ROI_dim = ROIs_to_keep(i,3);
        defocus_ind = ROI_dim_to_defocus_ind(handles,ROI_dim);
        defocuses(i) = defocus_array(defocus_ind);
    end

    if num_found<num_mol
        msgbox(sprintf('found only %d/%d molecules',counter,num_mol));
    end

    analysis_info.current_defocus_ind = 1;
    analysis_info.num_mol = num_added_mol;


