function simulate_video_2(handles)

    z = 0; % the molecule is in the middle of the film lets say. (Doesn't change much)    
    NA = 1.45;
    n0 = 1.52;
    n = 1.33; % PVA    
    n1 = 1.33;
    d0 = [];
    d = 1e-3; % 20 nm film
    d1 = [];
    lamem = 0.640;
    mag = 96;
    atf = [];
    ring = [];
    pixel = 16;
    nn = 12;
    block = 2; % in mm
    focus = -1.2;


%     theta = 60*ones(12,1);
%     phi = 0:30:330;
    video_length = 500;
    frame_dim = 128;
    video = zeros(frame_dim,frame_dim,video_length);
    num_par = 1;
    
    if num_par == 1
        xs = 64-12;
        ys = 64-12;
    else
        xs = randi([1 frame_dim-24],num_par,1);
        ys = randi([1 frame_dim-24],num_par,1);
    end
    

    
    [intx, inty, intz, rho, ~, fxx0, fxx2, fxz, byx0, byx2, byz] = ...
        SEPDipole([0 1.5*max(nn)*pixel/mag], z, NA, n0, n, n1, d0, d, d1, lamem, mag, focus, atf, ring, block);

%     f1=figure;
%     ax1=axes(f1);
%     thetas = zeros(num_par,1);
%     phis = zeros(num_par,1);
    thetas = randi([60 65],10,1);
    phis = randi([0 360],10,1);
%     thetas = 90;
%     phi = 0;

    max_int_pat = 100;
    min_theta = 50;
    max_theta = 180-min_theta;


    wait_bar = waitbar(0,sprintf('frame %d/%d', 0,video_length));
    for i=1:video_length
        frame = zeros(frame_dim,frame_dim);
        for j=1:num_par
            if i>1
                sigma_theta = 10;
                thetas(j) = thetas(j) + normrnd(0,sigma_theta);
                if thetas(j)<min_theta
                    thetas(j) = min_theta;
                end
                if thetas(j)>max_theta
                    thetas(j) = max_theta;
                end
                sigma_phi = 0*j;
                phis(j) = phis(j)+normrnd(0,sigma_phi);
            end

            rad_theta = 2*pi/360*thetas(j);    
            rad_phi = 2*pi/360*phis(j);

            pattern = SEPImage(rad_theta,-rad_phi,nn,pixel,rho,fxx0,fxx2,fxz,byx0,byx2,byz);    
%             disk = Disk(12);
%             zer = find(disk==0);
%             pattern(zer) = 0;

            mx = max(pattern(:));
            pattern = pattern * max_int_pat/ mx;
            

            frame(ys(j):ys(j)+24,xs(j):xs(j)+24) = frame(ys(j):ys(j)+24,xs(j):xs(j)+24) + pattern;



        end
%         mx = max(frame(:));
%         frame = frame+ mx/8 * rand(frame_dim,frame_dim);
%         for m=1:4:frame_dim
%             for n=1:4:frame_dim
%                 num = mx/8*rand();
%                 bulk = num*ones(4);
%                 frame(m:m+3,n:n+3) = frame(m:m+3,n:n+3) + bulk;
%             end
%         end
        noise_factor = 0.2;
        frame = frame + noise_factor * max_int_pat * rand(frame_dim,frame_dim);
        
        video(:,:,i) = video(:,:,i) + frame;
        if ~mod(i,10)
            waitbar(i/video_length,wait_bar,sprintf('frame %d/%d', i,video_length));    
        end
    end
    close(wait_bar);

%     saveastiff(video, 'vid.tif');
%     save('thetas','thetas');
%     save('phis','phis');
    path = handles.pathname.String;
    filename = handles.filename.String;
    final_path = [path '\' filename '.tif'];
    
    options.overwrite = 1;
%     saveastiff(uint16(single(video)/255*(2^16-1)), 'vid.tif',options);
    saveastiff(video, final_path, options);
    


    update_handles(handles.figure1, handles);
