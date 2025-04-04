function [positions,ints,num_mol] = find_positions_when_focused(analysis_settings,analysis_info,frame)
        
    positions = [];
    ints = [];
    
    num_mol = 0;
    int_min = analysis_info.intensity_threshold;
%     int_min = 3000;
    
    % sort all pixels by intensity
    [int,ind] = sort(frame(:),'descend');
    [ys,xs] = ind2sub(size(frame),ind);

    borders = analysis_info.borders;
    use_radius = analysis_settings.position_filter_by_radius;
    max_radius = analysis_settings.max_radius;
    dim_vid = analysis_info.dim_vid;
    center_x = analysis_settings.center_x_definition;
    center_y = analysis_settings.center_y_definition;
  
%     min_intermolecular_distance = analysis_settings.min_intermolecular_distance; % um
%     min_intermolecular_distance_pixels = min_intermolecular_distance / 0.174;

    for i=1:length(ys)
        y = ys(i);
        x = xs(i);

%         position_filter(x,y,analysis_info.borders,analysis_info.borders)
        if ~position_filter(x,y,borders,use_radius,max_radius,dim_vid,center_x,center_y)
            continue;
        end

        curr_int = frame(y,x);
        if curr_int<int_min
            break; % from here everything is lower by definition
        end 

        % get peaks which are at least 1500nm apart - otherwise they might
        % be pixels of the same molecule
        distinct_peak_distance = 10;
        if ~distance_filter(x,y,positions,distinct_peak_distance)
            continue;
        end
        % remove similar later

        positions = [positions; x y];     
        ints = [ints; curr_int];
        num_mol = num_mol + 1;    

    end

    fprintf('found %d molecules\n', num_mol);







