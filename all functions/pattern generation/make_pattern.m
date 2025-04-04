function pattern = make_pattern(z,NA,n0,n,n1,d0,d,d1,lamem,mag,atf,ring,pixel,nn,block,focus,theta,phi)
    [intx, inty, intz, rho, ~, fxx0, fxx2, fxz, byx0, byx2, byz] = ...
        SEPDipole([0 1.5*max(nn)*pixel/mag], z, NA, n0, n, n1, d0, d, d1, lamem, mag, focus, atf, ring, block);
    pattern = SEPImage(-theta,phi,nn,pixel,rho,fxx0,fxx2,fxz,byx0,byx2,byz);

