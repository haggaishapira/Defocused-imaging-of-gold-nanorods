function [final_positions,final_ints,num_mol_all] = find_positions_when_focused(analysis_settings,analysis_info,frame)
        
    all_positions = [];
    all_ints = [];
    
    num_mol_all = 0;
    int_min_final = analysis_info.intensity_threshold;
    int_min_all = int_min_final/2;

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
  
    for i=1:length(ys)
        y = ys(i);
        x = xs(i);

%         position_filter(x,y,analysis_info.borders,analysis_info.borders)
        if ~position_filter(x,y,borders,use_radius,max_radius,dim_vid,center_x,center_y)
            continue;
        end

        curr_int = frame(y,x);
        if curr_int<int_min_all
            break; % from here everything is lower by definition
        end 

        all_positions = [all_positions; x y];     
        all_ints = [all_ints; curr_int];
        num_mol_all = num_mol_all + 1;    

    end

    final_positions = [];
    final_ints = [];
    num_mol_final = 0;

    % reiterate
    % get peaks which are at least 1500nm apart - otherwise they might
    % be pixels of the same molecule
    min_intermolecular_distance = analysis_settings.min_intermolecular_distance; % um
    min_intermolecular_distance_pixels = min_intermolecular_distance / 174;
%     distinct_peak_distance = 10;

    for i=1:num_mol_all
        curr_int = all_ints(i);
        if curr_int<int_min_final
            break; % from here everything is lower by definition
        end 

        position = all_positions(i,:);
        x = position(1);
        y = position(2);
        if ~distance_filter(x,y,final_positions,min_intermolecular_distance_pixels)
            continue;
        end

        final_ints = [final_ints; curr_int];
        final_positions = [final_positions; x y];     
        num_mol_final = num_mol_final + 1;    

    end

    fprintf('found %d molecules\n', num_mol_final);







