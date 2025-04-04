function [filtered_step_reactions,num_dissociations] = filter_step_reactions(step_reactions,anti_fuel_num,first_t,last_t,...
                                                            settings)

    filtered_step_reactions = [];
    num_dissociations = 0;

    for i=1:length(step_reactions)
        step = step_reactions(i);


        if step.start_time < first_t || step.start_time > last_t
            continue;
        end
%         min_step_time = 10;
%         max_step_time = 60;
        min_step_size = settings.min_step_size;
        max_step_size = settings.max_step_size;

        if ~ismember(step.anti_fuel_num,anti_fuel_num)
            continue;
        end

        abs_step_size = step.step_size_total;
        % step size
        if abs_step_size < min_step_size || abs_step_size > max_step_size
            continue;
        end
%         if abs_step_size > max_step_size
%             continue;
%         end


        % wrong direction
%         min_wrong = 10;
%         if step.step_size < -min_wrong && step.clockwise || step.step_size > min_wrong && ~step.clockwise
% %         if ~(step.step_size < 0 && step.clockwise || step.step_size > 0 && ~step.clockwise)
%             continue;
%         end        

        if isinf(step.step_t_1) || isinf(step.step_t_2)
            continue;
        end
%         if step.relative_step_t_1 < settings.min_relative_step_time || step.relative_step_t_2 < settings.min_relative_step_time
        if step.relative_step_t_2 < settings.min_relative_step_time
            continue;
        end
%         if step.relative_step_t_1 > settings.max_relative_step_time || step.relative_step_t_2 > settings.max_relative_step_time
        if step.relative_step_t_2 > settings.max_relative_step_time
            continue;
        end

%               look at steps individually
%         show_clockwise = 0; show_anti_clockwise = 0;
%         show_clockwise = 0; show_anti_clockwise = 1;
%         show_clockwise = 1; show_anti_clockwise = 0;
%         show_clockwise = 1; show_anti_clockwise = 1;
        show_clockwise = settings.clockwise;
        show_anti_clockwise = settings.anti_clockwise;

        if step.clockwise && ~show_clockwise
            continue;
        end
        if ~step.clockwise && ~show_anti_clockwise
            continue;
        end

%       %%% for making histogram %%%
%         if step.clockwise && nargin > 4 && ~show_clockwise
%             continue;
%         end
%         if ~step.clockwise && nargin > 4 && ~show_anti_clockwise
%             continue;
%         end

        % filter for multiple changes - false positive - maybe too much noise
%         if step.num_changes > 1
%             continue; 
%         end        

        % filter for intermediate step
        if ~(step.intermediate && (step.step_t_2 - step.step_t_1)> 0 && step.step_size_1 > 10 && step.step_size_2 > 10)
%             continue; 
        end        
        % filter for dissociation
        dissociation = step.is_error;
        if dissociation
            num_dissociations = num_dissociations + 1;
            continue;
        end  

%         avg_step_sizes = [30 40 30 27 27 26];
        avg_step_sizes = [30 40 29 25 25 23];
        thresh = 30;
        abnormally_large_step = abs_step_size > avg_step_sizes(step.anti_fuel_num) + thresh;
        if abnormally_large_step
            num_dissociations = num_dissociations + 1;
            continue;
        end  

        abnormally_small_step = abs_step_size < avg_step_sizes(step.anti_fuel_num) / 2;
        if abnormally_small_step
%             continue;
        end  


%         disp(abs_step_size);

        filtered_step_reactions = [filtered_step_reactions; step];
    end

%     disp(length(filtered_step_reactions));



    