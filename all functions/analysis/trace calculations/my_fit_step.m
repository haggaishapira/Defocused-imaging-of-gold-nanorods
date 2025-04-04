function step_reaction = my_fit_step(settings,phi,t,frame_start,...
                                    frame_end,stepping_error,command_name,i,sequence_info)


%     disp('fitting start');


%     num_states = 3;

    len = length(t);
    mid_frame = round(length(t)/2);

    state_1 = min(phi);
    state_2 = max(phi);
    state_mid = (state_1 + state_2) / 2;
%     state_mid = state_1;
%     state_mid = state_2;
    frame_step_1 = mid_frame;
    frame_step_2 = mid_frame;

%     frame_step_1 = frame_step_1-50;
%     frame_step_2 = frame_step_2-20;

    initialguess = [state_1 state_2 state_mid frame_step_1 frame_step_2];

    min_state_1 = state_1 - 50;
    max_state_1 = state_2;

    min_state_2 = state_1;
    max_state_2 = state_2 + 50;

    min_state_mid = min_state_1;
    max_state_mid = max_state_2;

    min_t_step_1 = round(mid_frame * 0.9);
    max_t_step_1 = len;

    min_t_step_2 = min_t_step_1;
    max_t_step_2 = len;

    lb = [min_state_1 min_state_2 min_state_mid min_t_step_1 min_t_step_2];
    ub = [max_state_1 max_state_2 max_state_mid max_t_step_1 max_t_step_2];
    
    optFunc = @custom_step_function;

%     options = optimset('lsqcurvefit');
%     options = optimset(options, 'Jacobian','off', 'Display','off',  'TolX',10^-2, 'TolFun',10^-2,...
%                     'MaxPCGIter',1, 'MaxIter',500, 'DiffMinChange',1);
%     [paramsFit, ~] = lsqcurvefit(... 
%               optFunc, ... % Function to optimize
%               initialguess, t, phi,... % p0, xdata, ydata
%               lb, ub, options); % params: [x0, y0, sx, sy, background, amplitude]
    
    
%     paramsFit = my_minimization_function(optFunc, initialguess, lb, ub, step_sizes);

    consts = t;
    step_sizes = [100 50 10 5 2 1];
    [paramsFit,error] = my_chi_squared_minimization_function(optFunc, initialguess, consts, phi, lb, ub, step_sizes);

%     disp(curr_val);
%     fprintf('%.0f\n',curr_val);
    

    switch command_name
        case 'AF1'
            anti_fuel_num = 1;
        case 'AF2'
            anti_fuel_num = 2;
        case 'AF3'
            anti_fuel_num = 3;
        case 'AF4'
            anti_fuel_num = 4;
        case 'AF5'
            anti_fuel_num = 5;
        case 'AF6'
            anti_fuel_num = 6;
    end
    previous_fuel_command_name = sequence_info.command_names_full_sequence{i-5};
    switch previous_fuel_command_name
        case 'F1'
            previous_fuel_num = 1;
        case 'F2'
            previous_fuel_num = 2;
        case 'F3'
            previous_fuel_num = 3;
        case 'F4'
            previous_fuel_num = 4;
        case 'F5'
            previous_fuel_num = 5;
        case 'F6'
            previous_fuel_num = 6;
        otherwise
            previous_fuel_num = 1;
    end
    clockwise = 1+mod(anti_fuel_num + 2 - 1,6) == previous_fuel_num;
    AF_start_t = sequence_info.time_intervals(i,1);

    paramsFit = process_params(paramsFit);

    state_1 = paramsFit(1);
    state_2 = paramsFit(2);
    state_mid = paramsFit(3);
    frame_step_1 = round(paramsFit(4));
    frame_step_2 = round(paramsFit(5));

    step_t_1 = t(frame_step_1);
    step_t_2 = t(frame_step_2);

    % larger step
    delta_1 = state_mid - state_1;
    delta_2 = state_2 - state_mid;

    threshold_step_size = 7;
    
    intermediate = 1;
    if delta_1 > delta_2
        if delta_2 < threshold_step_size
            intermediate = 0;
            state_mid = state_2;
            step_t_2 = step_t_1;
        end
    else
        if delta_1 < threshold_step_size
            intermediate = 0;
            step_t_1 = step_t_2;
            state_mid = state_2;
            frame_step_1 = frame_step_2;
        end
    end

    paramsFit = [state_1 state_2 state_mid frame_step_1 frame_step_2];

    fitted_trace = custom_step_function(paramsFit,t);

%     stepping_error = error > 10^7;

    step_reaction = make_step_reaction(AF_start_t,state_1,state_2,intermediate,state_mid,step_t_1,step_t_2,...
                    anti_fuel_num,t,fitted_trace,clockwise,stepping_error);






