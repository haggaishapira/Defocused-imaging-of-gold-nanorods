function [handles,molecules] = GPU_batch_analysis(handles)

 %analyze with GPU in batches (each batch's least squares
            %calculation is done with GPU in parallel, the other parts are done sequentially with CPU)
            wait_bar = waitbar(0,sprintf('frame %d/%d', 0,vid_len));
            dev = gpuDevice;
            total_mem = 4*10^9;
            batch_num_frames = min(round(total_mem/8/num_pat/len_pat/num_mol), vid_len); 
%             batch_num_frames = 1;
            
            patterns_gpu = gpuArray(zeros(len_pat,num_mol*batch_num_frames*num_pat));
            start = 1;
            for i=1:num_pat
                patterns_gpu(:,start:start+num_mol*batch_num_frames-1) = ...
                    repmat(patterns(:,i),1,num_mol*batch_num_frames);
                start = start + num_mol * batch_num_frames;
            end   
            ROI_mat = gpuArray(zeros(len_pat,num_mol*batch_num_frames));
            
            % iterate frames here
            for i=1:batch_num_frames:vid_len
%                 CPU_time = 0;
%                 GPU_time = 0;
%                 memory_time = 0;
                
%                 tic
                [handles, frame] = get_frame(handles,i);
%                 memory_time = memory_time + toc;
%                 tic
                set(handles.ax_video.Children(end),'CData',frame);
                max_ind_batch = min(i+batch_num_frames-1,vid_len);
                batch_frames_ind = i:max_ind_batch;
                final_num_frames_to_batch = length(batch_frames_ind);
                counter = 1;
%                 disp(max_ind_batch);
                for k=i:max_ind_batch
%                     tic
                    [handles, frame] =  get_frame(handles,k);                    
%                     memory_time = memory_time + toc;
%                     tic
                    %%% tracking
                    tracking_correction = 1;
%                     tracking_correction = 0;
                    if tracking_correction && ~mod(k,100)
                        set(handles.ax_video.Children(end),'CData',frame);
                        current_frames = zeros(512,512,100);
                        for fr=1:min(100,vid_len-k+1)
                            [handles, frame] = get_frame(handles,k+fr-1);  
                            current_frames(:,:,fr) = frame;
                        end
                        avg_current_frames = sum(current_frames,3)/100;
                        frame = double(avg_current_frames);
                        ROI_im_old = reference_frame(start_y:end_y,start_x:end_x);

                        [best_dy,best_dx] = correlation_hill_climbing(frame, ROI_im_old,current_dy,current_dx);
                        delta_y = best_dy - current_dy;
                        delta_x = best_dx - current_dx;
                        current_dy = best_dy;
                        current_dx = best_dx;
                        remaining_frames = vid_len - k + 1;
                        for mol=1:num_mol
                            h = molecules(mol).ROI_handle;
                            pos = getPosition(h);
                            pos(1) = pos(1) + delta_x;
                            pos(2) = pos(2) + delta_y;
                            setPosition(h,pos);
                            molecules(mol).ROI(:,k:end) = repmat(pos',1,remaining_frames);
                        end                        
                    end
                    

                    for j=1:num_mol
%                         molecule = molecules(j);
                        ROI = molecules(j).ROI(:,i);
                        ROI_image = get_integer_pixel_ROI_image(frame, ROI);
                        ROI_image = double(ROI_image);
                        % calc int back here
                        [int,back] = calc_intensity(ROI_image);
                        molecules(j).int(k) = int;
                        molecules(j).back(k) = back;
                        ROI_image = ROI_image - min(ROI_image(:));
                        ROI_image = ROI_image/sum(ROI_image(:));

                        ROI_mat(:,counter) = ROI_image(:);
% %                         ROI_mat(:,counter) = def_im;
%                         
                        counter = counter+1;
%                         molecules(j) = molecule;
                    end
%                     CPU_time = CPU_time + toc;
                end

                
                num_ROIs = size(ROI_mat,2);
    
                sum_sqs = gpuArray(inf*ones(num_pat,num_ROIs));
                start = 1+min_theta/10*72;
                for n=start:num_pat
                    sqs = (patterns_gpu(:,(n-1)*num_ROIs+1:n*num_ROIs)-ROI_mat).^2;
                    sum_sqs(n,:) = sum(sqs,1);
                end

                [min_sqs,angles] = min(sum_sqs);
                angles = gather(angles);
%                 angles = ones(num_ROIs,1);

%                 GPU_time = GPU_time + toc;
%                 fprintf('GPU time: %.2f\n',toc);
%                 tic
                [thetas,phis] = angle_to_theta_phi(angles,res_theta,res_phi,num_phi);
                
                
                for j=1:num_mol
                    ind_mol = j:num_mol:num_mol*final_num_frames_to_batch;
                    molecules(j).theta_half(i:i+final_num_frames_to_batch-1) = thetas(ind_mol);
                    molecules(j).phi_half(i:i+final_num_frames_to_batch-1) = phis(ind_mol);
                end
                

                
                num = i+batch_num_frames-1;
                waitbar(num/vid_len,wait_bar,sprintf('frame %d/%d', num,vid_len));
%                 CPU_time = CPU_time + toc;
%                 fprintf('CPU time: %.2f\n',CPU_time/final_num_frames_to_batch);
%                 fprintf('GPU time: %.2f\n',GPU_time/final_num_frames_to_batch);
%                 fprintf('memory time: %.2f\n',memory_time/final_num_frames_to_batch);
%                 fprintf('total time: %.2f\n\n',(CPU_time++memory_time)/final_num_frames_to_batch);
            end
            waitbar(vid_len,wait_bar,sprintf('frame %d/%d', vid_len,vid_len));
            
            for j=1:num_mol       
                molecule = molecules(j);
                %frame 1
                molecule.theta_whole(1) = molecule.theta_half(1);
                molecule.phi_whole(1) = molecule.phi_half(1);
                molecule.trace_theta_half(1) = molecule.theta_half(1);
                molecule.trace_phi_half(1) = molecule.phi_half(1);
                molecule.trace_theta_whole(1) = molecule.theta_half(1);
                molecule.trace_phi_whole(1) = molecule.phi_half(1);
                molecule.trace_phi_whole(1) = molecule.phi_half(1);
                for i=2:vid_len
                    prev_theta_whole = molecule.theta_whole(i-1);
                    prev_phi_half = molecule.phi_half(i-1);
                    prev_phi_whole = molecule.phi_whole(i-1);
                    next_theta_half = molecule.theta_half(i);
                    next_phi_half = molecule.phi_half(i);
%                     molecules(j).half_sphere_theta
                    [next_theta_whole,next_phi_whole] = ...
                        half_sphere_to_whole(prev_theta_whole,prev_phi_whole,next_theta_half,next_phi_half);
                    molecule.theta_whole(i) = next_theta_whole;
                    molecule.trace_theta_half(i) = molecule.theta_half(i);
                    molecule.trace_theta_whole(i) = molecule.theta_whole(i);
                    molecule.phi_whole(i) = next_phi_whole; 
                    %calc trace
                    %trace theta is defined just as whole sphere theta
                    molecule.trace_theta_whole(i) = next_theta_whole;
%                     old_trace_phi_whole = molecule.trace_phi(i-1);
                    delta_phi_half = get_delta_phi(prev_phi_half,next_phi_half);
                    delta_phi_whole = get_delta_phi(prev_phi_whole,next_phi_whole);
                    molecule.trace_phi_half(i) = molecule.trace_phi_half(i-1) + delta_phi_half;
                    molecule.trace_phi_whole(i) = molecule.trace_phi_whole(i-1) + delta_phi_whole;
%                 [x_arrow,y_arrow] = get_arrow_coordinates(vid_size,ROI,phi,pos);
%                 set(molecule.arrow,'X',x_arrow,'Y',y_arrow);
                end
                molecules(j) = molecule;
%                 disp(max(molecule.trace_phi_half(2:end) - molecule.trace_phi_half(1:end-1)));
            end
            close(wait_bar);