function [handles,acq] = delay_stuff(handles,acq)

        t_check = toc;
%         disp(t_check);
        delay = t_check - double(acq.i_total)/acq.framerate;

%         disp(acq.framerate);

        handles.real_time.String = sprintf('%.3f',t_check);
        handles.delay.String = sprintf('%.3f',delay);
        if delay<1
            if acq.synthetic && delay<0
                pause(-delay);
            end
            delay = max(delay,0);
            col = [0 1 0] + delay * [1 -1 0];
        else
            col = [1 0 0];
        end
        new_delay_col = round(col,2);
        if ~isequal(new_delay_col,acq.delay_col)
            handles.delay.BackgroundColor = new_delay_col;
            acq.delay_col = new_delay_col;
        end
        
        if acq.synthetic 
            pause(-delay);
        end
