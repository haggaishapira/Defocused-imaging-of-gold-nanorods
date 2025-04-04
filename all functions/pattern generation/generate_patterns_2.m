function patterns = generate_patterns_2(settings)   
    z = settings.z;
    NA = settings.NA;
    n0 = settings.n0;
    n = settings.n;
    n1 = settings.n1;
    d0 = settings.d0;
    d = settings.d;
    d1 = settings.d1;
    lamem = settings.lamem;
    mag = settings.mag;
    atf = settings.atf;
    ring = settings.ring;
    pixel = settings.pixel;
    nn = settings.nn;
    block = settings.block;
    defocus = settings.defocus;
    res_theta = settings.res_theta;
    res_phi = settings.res_phi;
    num_smooth = settings.num_smooth;
    
    
    d0 = [];
    d1 = [];
    atf = [];
    ring = [];
    
    
%     bck = Disk(nn);
    dim = 2*nn+1;
    thetas = 0:res_theta:90;
    thetas = thetas * 2*pi/360;
    phis = 0:res_phi:360;
    phis = phis * 2*pi/360;
    phis = phis(1:end-1);
        
    patterns = zeros(length(thetas), length(phis),dim,dim);
    wait_bar_theta = waitbar(0,sprintf('generating patterns, defocus=%.1f',defocus),'Position',[800 400 300 50]);
    counter = 1;
    [intx, inty, intz, rho, ~, fxx0, fxx2, fxz, byx0, byx2, byz] = SEPDipole([0 1.5*max(nn)*pixel/mag], z, NA, n0, n, n1, d0, d, d1, lamem, mag, defocus, atf, ring, block);
    for theta_ind=1:length(thetas)
        for phi_ind=1:length(phis)
            pattern = SEPImage(thetas(theta_ind),phis(phi_ind)-pi/2,nn,pixel,rho,fxx0,fxx2,fxz,byx0,byx2,byz);
            for i=1:num_smooth
                pattern = smooth_image(pattern);
            end
            pattern = pattern / sum(pattern(:));
%             patterns(counter,:,:) = pattern;
            patterns(theta_ind,phi_ind,:,:) = pattern;
%             counter = counter + 1;
        end
        waitbar(theta_ind/length(thetas),wait_bar_theta,sprintf('generating patterns, defocus=%.1f',defocus));
    end
    close(wait_bar_theta);
end







