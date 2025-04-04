function [best_dy,best_dx] = correlation_hill_climbing(ref_frame,new_frame, ROI_rad, center_x, center_y, current_dx, current_dy, max_drift)
    
%     pix_cut = 20;
%     dim_vid = size(new_frame,1);

%     dim_vid = 

%     start_x = 1+pix_cut;
%     end_x = 512-pix_cut;
%     start_y = 1+pix_cut;
%     end_y = 512 - pix_cut;

    temp_best_corr = -inf;
%     max_drift = 100;

    dx = current_dx;
    dy = current_dy;

%     ROI_im_ref = ref_frame(start_y:end_y,start_x:end_x);
%     ROI_im_ref = ROI_im_ref / sum(ROI_im_ref(:));

%     ROI_im_new = new_frame(start_y+dy:end_y+dy,start_x+dx:end_x+dx);
%     ROI_im_new = ROI_im_new / sum(ROI_im_new(:));

    ROI_im_ref = ref_frame(center_y-ROI_rad:center_y+ROI_rad, center_x-ROI_rad:center_x+ROI_rad);
    ROI_im_ref = ROI_im_ref / sum(ROI_im_ref(:));

    ROI_im_new = new_frame(dy+(center_y-ROI_rad:center_y+ROI_rad), dx+(center_x-ROI_rad:center_x+ROI_rad));
    ROI_im_new = ROI_im_new / sum(ROI_im_new(:));


%     disp('start hill climbing');
    
    mul = ROI_im_ref.*ROI_im_new;
%     mul = norm_ROI_im_old.*norm_ROI_im_check;
    current_corr = sum(mul(:));    
    delta_max = 1;
    
    while delta_max>0
        delta_max = 0;
        %try 4 directions
        dys_to_try = [dy+1 dy dy dy-1];
        dxs_to_try = [dx dx+1 dx-1 dx];
        for i=1:4
            if dys_to_try(i)<-max_drift || dys_to_try(i)>max_drift || ...
                    dxs_to_try(i)<-max_drift || dxs_to_try(i)>max_drift
                continue 
            else
%                 counter = counter + 1;
            end
%             ROI_im_new = new_frame(start_y+dys_to_try(i):end_y+dys_to_try(i),...
%                 start_x+dxs_to_try(i):end_x+dxs_to_try(i));
            curr_dx_try = dxs_to_try(i);
            curr_dy_try = dys_to_try(i);
            ROI_im_new = new_frame(curr_dy_try+(center_y-ROI_rad:center_y+ROI_rad), curr_dx_try+(center_x-ROI_rad:center_x+ROI_rad));
            ROI_im_new = ROI_im_new / sum(ROI_im_new(:));

%             ROI_im_new = ROI_im_new / sum(ROI_im_new(:));
            mul = ROI_im_ref.*ROI_im_new;
%             mul = norm_ROI_im_old.*norm_ROI_im_check;
            corr = sum(mul(:));
%             corrs(dy+max_shift+1,dx+max_shift+1) = corr;
            
            
            delta = corr - current_corr;
            if delta > delta_max
                delta_max = delta;
                temp_best_corr = corr;
                dy =  dys_to_try(i);
                dx =  dxs_to_try(i);
                fprintf('dx: %d, dy: %d, corr: %d\n\n', dx, dy, corr);
            end
        end
        current_corr = temp_best_corr;
    end
    best_dy = dy;
    best_dx = dx;
