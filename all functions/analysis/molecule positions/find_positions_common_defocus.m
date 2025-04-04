function [positions,num_mol,defocus_inds,theta_inds,phi_inds] = ...
                    find_positions_common_defocus(analysis_settings,analysis_info,frame,avg_frame)

%     borders = analysis_info.borders;
    patterns = analysis_info.patterns;
%     distinct_mol_distance = 10;
    min_fit = 0.00001;
%     rings = analysis_info.rings;
    num_mol = 0;
    desired_num_mol = analysis_info.desired_num_mol;

    rings = analysis_info.rings;
%     ring = rings(:,:,defocus_ind);
%     dim_vid = size(avg_frame,1);
%     fitting_matrix = zeros(dim_vid);
    borders = analysis_info.borders;
    use_radius = analysis_settings.position_filter_by_radius;
    max_radius = analysis_settings.max_radius;
    dim_vid = analysis_info.dim_vid;
    center_x = analysis_settings.center_x_definition;
    center_y = analysis_settings.center_y_definition;

    positions = [];
    defocus_inds = [];
    theta_inds = [];
    phi_inds = [];

    defocus_ind = analysis_info.current_defocus_ind; % this will determine the size of the ring

    % assign a value to each pixel according to ring fitting
%     [fits,inds] = sort_positions_by_ring_fitting(handles,avg_frame, ROI_dim, analysis_info.original_mask, result_matrix);
    ring_fitting_matrix = calculate_ring_fitting_matrix(analysis_settings,analysis_info,defocus_ind,avg_frame);

    % sort all pixels by intensity
    [int,ind] = sort(ring_fitting_matrix(:),'descend');
    [ys,xs] = ind2sub(size(ring_fitting_matrix),ind);

%     dim_vid = size(avg_frame,1);
    
    for i=1:length(ys)
        if desired_num_mol == 0
            break;
        end
        y = ys(i);
        x = xs(i);
        
        if ~position_filter(x,y,borders,use_radius,max_radius,dim_vid,center_x,center_y)
%         if ~position_filter(x,y,analysis_info.borders)
            continue;
        end

        curr_fit = ring_fitting_matrix(y,x);
        if curr_fit < min_fit
            break; % from here everything is lower by definition
        end 

        % get molecules which are at least 4um apart
        min_distance_pixels = analysis_info.min_distance_pixels;
        if ~distance_filter(x,y,positions,min_distance_pixels)
            continue;
        end

        [pass,defocus_ind,theta_ind,phi_ind] = pattern_matching_filter...
                                    (frame,avg_frame,patterns,rings,x,y,defocus_ind);
        if ~pass
            continue;
        end

        positions = [positions; x y];     
        defocus_inds = [defocus_inds; defocus_ind];
        theta_inds = [theta_inds; theta_ind];
        phi_inds = [phi_inds; phi_ind];

        num_mol = num_mol + 1;    
        if num_mol == desired_num_mol
            break;
        end
    end

    fprintf('found %d molecules\n', num_mol);


%     [positions,fitting_values,num_mol] = select_positions_from_value_matrix(borders,fitting_matrix,distinct_mol_distance,min_fit);

    desired_num_mol = analysis_info.desired_num_mol;

    if num_mol<analysis_info.desired_num_mol
        msgbox(sprintf('found only %d/%d molecules',num_mol,desired_num_mol));
    end












    

