function fitting_matrix = calculate_ring_fitting_matrix(analysis_settings,analysis_info,defocus_ind,avg_frame)

    rings = analysis_info.rings;
    ring = rings(:,:,defocus_ind);
    dim_vid = size(avg_frame,1);
    fitting_matrix = zeros(dim_vid);
    borders = analysis_info.borders;
    use_radius = analysis_settings.position_filter_by_radius;
    max_radius = analysis_settings.max_radius;
    dim_vid = analysis_info.dim_vid;
    center_x = analysis_settings.center_x_definition;
    center_y = analysis_settings.center_y_definition;


    for y=1:dim_vid
        for x=1:dim_vid
            if ~position_filter(x,y,borders,use_radius,max_radius,dim_vid,center_x,center_y)
%             if ~position_filter(x,y,borders)
                continue;
            end
            fitting_matrix(y,x) = calculate_ring_fitting(avg_frame,ring,x,y); % positive is better
        end
    end
%     [fits,inds] = sort(fitting_matrix(:), 'descend'); 
