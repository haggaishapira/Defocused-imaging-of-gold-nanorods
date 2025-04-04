function [video,trace_theta,trace_phi,pat_theta,pat_phi] = simulate_video(handles)

    settings = handles.settings_simulation;
    video_length = settings(1);
    frame_size = settings(2);
    num_mol = settings(3);
    num_smooths = settings(4);
    use_noise = settings(5);
    signal_to_noise = settings(6);
    sigma_theta = settings(7);
    sigma_phi = settings(8);
    z = settings(9); % the molecule is in the middle of the film lets say. (Doesn't change much)    
    NA = settings(10);
    n0 = settings(11);
    n = settings(12); % PVA    
    n1 = settings(13);
    d0 = settings(14);
    d = settings(15); % 20 nm film
    d1 = settings(16);
    lamem = settings(17);
    mag = settings(18);
    atf = settings(19);
    ring = settings(20);
    pixel = settings(21);
    nn = settings(22);
    block = settings(23); % in mm
    focus = settings(24);

    d0 = [];
    d1 = [];
    atf = [];
    ring = [];
    
%     focus = -1.2;
%     pat_size = 41; %so nn=20
%     video = zeros(frame_size,frame_size,video_length);
    positions = zeros(num_mol,2,video_length);
    pat_size = nn*2+1;
    for j=1:num_mol
        positions(j,1,1) = 1 + round((frame_size-pat_size)*rand());
        positions(j,2,1) = 1 + round((frame_size-pat_size)*rand());
    end
    diffusion_const = 0;
    for i=2:video_length
        for j=1:num_mol
            positions(j,1,i) = positions(j,1,i-1) + round(normrnd(0,diffusion_const));
            positions(j,2,i) = positions(j,2,i-1) + round(normrnd(0,diffusion_const));
        end
    end
    
    trace_theta = zeros(video_length,num_mol);
    trace_phi = zeros(video_length,num_mol);
    pat_theta = zeros(video_length,num_mol);
    pat_phi = zeros(video_length,num_mol);

    pat_theta(1,:) = 10 + 70 * rand(1,num_mol);
    pat_phi(1,:) = 360 * rand(1,num_mol);
    trace_theta(1,:) = pat_theta(1,:);
    trace_phi(1,:) = pat_phi(1,:);
    
    for i=2:video_length
        for j=1:num_mol    
            new_theta = trace_theta(i-1,j) + normrnd(0,sigma_theta);
            %keep theta in range of 0-180
            if new_theta > 180
                new_theta = new_theta - 2*(new_theta-180);
            end
            if new_theta < 0
                new_theta = - new_theta;
            end
            trace_theta(i,j) = new_theta;
            new_phi = trace_phi(i-1,j) + normrnd(0,sigma_phi); 
            trace_phi(i,j) = new_phi;
            pat_phi(i,j) = mod(new_phi,360);
            pat_theta(i,j) = new_theta;
            if new_theta > 90
                %flip
                pat_theta(i,j) = 180 - new_theta;
                pat_phi(i,j) = mod(360,pat_phi(i,j)+180);
            end
%             if pat_theta(i,j) == 0
%                 pat_phi(i,j) = 0;
%             else
%                 if pat_theta(i,j) == 90
%                     pat_phi(i,j) = mod(pat_phi(i,j),180);
%                 end
%             end
        end
    end
%     video = generate_patterns_simulation(handles.settings_patterns,theta,phi);
    video = zeros(frame_size,frame_size,video_length);
    wait_bar_sim = waitbar(0,sprintf...
            ('theta %d/%d', 0,length(trace_theta)),'Position',[800 400 300 50]);

    rad_theta = 2*pi/360 * trace_theta;
    rad_phi = 2*pi/360 * trace_phi;
%     rad_theta = 2*pi/360 * pat_theta;
%     rad_phi = 2*pi/360 * pat_phi;
%     figure
    [intx, inty, intz, rho, ~, fxx0, fxx2, fxz, byx0, byx2, byz] = SEPDipole([0 1.5*max(nn)*pixel/mag],...
        z, NA, n0, n, n1, d0, d, d1, lamem, mag, focus, atf, ring, block);
    max_int = 0;
    for i=1:video_length
        for j=1:num_mol
            pattern = SEPImage(rad_theta(i,j),-rad_phi(i,j),nn,pixel,rho,fxx0,fxx2,fxz,byx0,byx2,byz);
            int = sum(pattern(:));
            if int > max_int;
                max_int = int;
            end
    %                 pattern = pattern.*bck;
    %                 pattern = pattern/sum(sum(pattern));
            start_y = positions(j,1,i);
            end_y = start_y + pat_size - 1;
            start_x = positions(j,2,i);
            end_x = start_x + pat_size - 1;
            video(start_y:end_y,start_x:end_x,i) = video(start_y:end_y,start_x:end_x,i) + pattern;
        end
        if ~mod(i,100)
            waitbar(i/video_length,wait_bar_sim,sprintf('frame %d/%d',i,video_length));
        end
    end
    close(wait_bar_sim);
    norm_max_int = 255*max_int/max(video(:)); %extrapolation, works like line below
%     norm_max_int_2 = interp1([0 max(video(:))],[0 255],max_int,'linear','extrap');
%     disp(norm_max_int);
%     disp(norm_max_int_2);
    video = interp1([0 max(video(:))],[0 255],video);
    if use_noise
        noise_val = norm_max_int / signal_to_noise / length(pattern(:)); 
        [y,x,len] = size(video);
        gen_num_back = 1000;
        back_pool = poissrnd(ones(gen_num_back,1) * noise_val);
        back = reshape(datasample(back_pool,y*x*len), [y,x,len]);
        video = video + back;
    end
%     close(wait_bar);
%     a=2;
    for i=1:video_length
        for s=1:num_smooths
            video(:,:,i) = smooth(video(:,:,i));
        end
    end

    
    
    
    
    
    
    
    
    
    
    
function next_theta = get_next_theta(old_theta,free_diff,max_theta_jump)
%     jmp = max_theta_jump / 10;
%     num = round(2 * jmp * rand()) - jmp; % -2,-1,0,1,2
    num = normrnd(0,10);
    next_theta = old_theta + num;
        
function next_phi = get_next_phi(old_phi,max_phi_jump)
%     jmp = max_phi_jump / 5;
%     num = round(2 * jmp * rand()) - jmp; % -1,0,1
    num = normrnd(0,10);
    next_phi = old_phi + num;
