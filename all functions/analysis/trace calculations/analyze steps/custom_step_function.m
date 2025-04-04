function fit_step = custom_step_function(params,t)


    params = process_params(params);

    state_1 = params(1);
    state_2 = params(2);
    state_mid = params(3);
    frame_step_1 = params(4);
    frame_step_2 = params(5);

    bad = 0;
    if frame_step_1>frame_step_2
        bad = 1;
    end
    if state_mid < state_1 || state_mid > state_2
        bad = 1;
    end
    if bad
        fit_step(:) = inf;
        return;
    end

    len = length(t);
    fit_step = zeros(len,1);
    fit_step(1:frame_step_1-1) = state_1;    

    % 2 steps
    fit_step(frame_step_1:frame_step_2-1) = state_mid;
    fit_step(frame_step_2:end) = state_2;

    % 1 step
%     fit_step(frame_step_1:end) = state_2;



%     if frame_step_2 < frame_step_1
%         fit_step(:) = 0;
%     end

%     disp(params);
%     fprintf('params:\nstate 1: %.0f\nstate 2: %.0f\nt step: %.3f\n\n', state_1,state_2,t(frame_step_1));
%     disp('');

    
    
    