%all in sphere
function delta_theta = get_delta_theta_cross(old_theta,new_theta,trace_old_theta)
    unit_trace_old_theta = mod(trace_old_theta,360);
%     if old_theta < 90
%         if unit_trace_old_theta < 90
%             delta_theta = - (old_theta + new_theta);
%         else
%             delta_theta = + (old_theta + new_theta);
%         end
%     else
%         if unit_trace_old_theta > 90
%             delta_theta = + ((180-old_theta) + (180-new_theta));
%         else
%             delta_theta = - ((180-old_theta) + (180-new_theta));
%         end
%     end
%     

    if unit_trace_old_theta > 90
        delta_theta = (180-old_theta) + (180-new_theta);
    else
        delta_theta = - (old_theta + new_theta);
    end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    