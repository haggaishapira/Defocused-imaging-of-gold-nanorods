
function [paramsFit,curr_error] = my_chi_squared_minimization_function(fun, x0, consts, y, lb, ub, step_sizes)

    
    num_params = length(x0);

    curr_params = x0;
    curr_error = chi_squared(fun(x0,consts),y);
    
    for i=1:num_params
        if x0(i) < lb(i) || x0(i) > ub(i)
            paramsFit = [];
            return;
        end
    end
    for i=1:length(step_sizes)
        step_size = step_sizes(i);    
        can_continue_global = true;    
        while can_continue_global
            can_continue_global = false;
            for j=1:num_params
                can_continue_local = true;
                while can_continue_local
                    can_continue_local = false;
                    temp_params_pos = curr_params;
                    temp_params_neg = curr_params;
                    temp_params_pos(j) = temp_params_pos(j) + step_size;
                    temp_params_neg(j) = temp_params_neg(j) - step_size;
                    pos_ok = temp_params_pos(j) <= ub(j); 
                    neg_ok = temp_params_neg(j) >= lb(j); 
                    if pos_ok
                        pos_error = chi_squared(fun(temp_params_pos,consts),y);
                        if pos_error < curr_error
                            curr_error = pos_error;
                            curr_params = temp_params_pos;
                            can_continue_local = true;
                            can_continue_global = true;
                        end
                    end
                    if neg_ok
                        neg_error = chi_squared(fun(temp_params_neg,consts),y);
                        if neg_error < curr_error
                            curr_error = neg_error;
                            curr_params = temp_params_neg;
                            can_continue_local = true;
                            can_continue_global = true;
                        end
                    end
                end
            end 
        end
    end
    paramsFit = curr_params;
        
