function [new_x,new_y,new_z] = gold_3d(delta_theta,delta_phi)

    delta_theta = double(delta_theta);
    delta_phi = double(delta_phi);
    factor = 2*pi/360;
    left_half = sin(factor* (0:30:90));
    right_half = sin(factor* (90:-30:0));
    middle = ones(1,20);
    vec = [left_half middle right_half];
    [x,y,z] = cylinder(vec);
    x = 12.5.*x;
    y = 12.5.*y;
    z = 60.*z - 30.5;
    
    r_tag = (x.^2+z.^2).^0.5;
    to_turn = x.^2+z.^2>0.00001;
    pos1 = to_turn & x>=0;
    pos2 = to_turn & ~pos1;
    psi = zeros(size(x));
    psi(pos1) = mod(atan(z(pos1)./x(pos1)), 2*pi);
    psi(pos2) = mod(atan(z(pos2)./x(pos2)) + pi, 2*pi);
    psi = psi+factor*delta_theta;
    new_x = r_tag.*cos(psi);
    new_z = r_tag.*sin(psi);

    r_tag = (y.^2+new_x.^2).^0.5;
    to_turn = new_x.^2+y.^2>0.00001;
    pos1 = to_turn & new_x>=0;
    pos2 = to_turn & ~pos1;
    phi = zeros(size(x));
    phi(pos1) = mod(atan(y(pos1)./new_x(pos1)), 2*pi);
    phi(pos2) = mod(atan(y(pos2)./new_x(pos2)) + pi, 2*pi);
    phi = phi + factor*delta_phi;

    new_x = r_tag.*cos(phi);
    new_y = r_tag.*sin(phi);

    



