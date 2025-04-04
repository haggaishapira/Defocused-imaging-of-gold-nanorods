function best_defocus_ind = find_defocus(handles,analysis_info)

    avg_frame = analysis_info.avg_frame;
    ROI_dim_array = analysis_info.ROI_dim_array;
    analysis_settings = handles.analysis_settings;

    % find best defocus
    num_mol = 10;
    [h_frame,w_frame,~]=size(avg_frame);
    frame1 = analysis_info.frame1;
    
    averages_lst_sq = zeros(5,1);
    num_defocuses = get_num_defocuses(handles);

    matrix = 1;
    flat = 1;

%     tic
    wait_bar = waitbar(0,sprintf('defocus %d/%d', 0,num_defocuses));    
    for i=1:num_defocuses
%         patterns = analysis_info.all_patterns{defocus_step};
        patterns = get_patterns(handles,i,matrix,flat);
        ROI_dim = ROI_dim_array(i);
        result_matrix = zeros(h_frame-ROI_dim+1,w_frame-ROI_dim+1);
        sorted_inds = sort_positions_by_ring_fitting(handles,avg_frame, ROI_dim, analysis_info.original_mask, result_matrix);
%         [ROIs,lst_sqs,num_found] = choose_molecules_from_best_rings(sorted_inds, ROI_dim, num_mol, result_matrix, frame1, patterns);
        [ROIs,lst_sqs,num_found] = choose_molecules_from_best_rings(analysis_info,analysis_settings,sorted_inds, ROI_dim, result_matrix, patterns);

        avg_lst_sq = mean(lst_sqs);
        averages_lst_sq(i) = avg_lst_sq;
%         toc
        waitbar(i/num_defocuses,wait_bar,sprintf('defocus %d/%d', i,num_defocuses));
    end
    close(wait_bar);

    [min_avg,min_avg_ind] = min(averages_lst_sq);
    best_defocus_ind = min_avg_ind;







