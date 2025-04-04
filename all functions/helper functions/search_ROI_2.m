function best_ROI = search_ROI_2(handles,frame,ROI)
%     pat_ring = squeeze(handles.patterns(9,1,1,:,:));
%     ROI = handles.molecules(mol).ROI;
    borders = ROI_to_borders(ROI); %left top right bottom
    can_continue = true;    
    mask = handles.ring;
    [h_frame,w_frame] = size(frame);
    max_step_size = 1;
    best_ROI = ROI;
    im = get_integer_pixel_ROI_image(frame,ROI);
%     im = im - min(im(:));
    im = my_transform_fit_size_2(im,ROI(3),25,ROI(4),25,0,0);
    im = im / sum(im(:));
    im = im(mask>0);
    max_int = sum(im(:));
%     im = (im(:))'; %make row
%     ROI_matrix = repmat(im,720,1);
%     patterns = handles.partial_patterns;
%     [theta,phi,min_lst_sq] = fit_pattern_least_squares(im(:),patterns); 
    while can_continue
        can_continue = false;
        for shift_hor = -max_step_size:max_step_size
            for shift_ver = -max_step_size:max_step_size
%                 for stretch = -max_step_size:max_step_size
                stretch = 0;
                    temp_borders = borders;
                    %first stretch ((ax+b) -> multiply by x then add b) \
                    temp_borders(1) = temp_borders(1) - stretch + shift_hor; %left
                    temp_borders(2) = temp_borders(2) - stretch + shift_ver; %top
                    temp_borders(3) = temp_borders(3) + stretch + shift_hor; %right
                    temp_borders(4) = temp_borders(4) + stretch + shift_ver; %bottom
                    left = temp_borders(1);
                    top = temp_borders(2);
                    right = temp_borders(3);
                    bottom = temp_borders(4); 
                    if left>=1 && top>=1 && right<=w_frame && bottom<=h_frame
                        temp_ROI = borders_to_ROI(temp_borders);
                        im = frame(top:bottom,left:right);
%                             im = im - min(im(:));
                        im = my_transform_fit_size_2(im,temp_ROI(3),25,temp_ROI(4),25,0,0);
                        im = im / sum(im(:));         
                        im(mask==0) = 0;
%                             im = (im(:))';
%                             ROI_matrix = repmat(im,720,1);
%                             [theta,phi,lst_sq] = fit_pattern_least_squares(im(:),patterns);
                        int = sum(im(:));
%                             disp(theta);
%                             disp(phi);
                        if int > max_int
                            borders = temp_borders;
                            max_int = int;
                            best_ROI = temp_ROI;
                            setPosition(handles.molecules(end).ROI_handle,best_ROI);  
%                             pause(0.1);
                            can_continue = true;
%                             pause(0.00001);
                        end
                    end
%                 end
            end
        end
    end
