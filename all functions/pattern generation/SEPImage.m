function [int, x, y, ex, ey, bx, by] = SEPImage(al,be,nn,pixel,rho,fxx0,fxx2,fxz,byx0,byx2,byz)

if length(nn)==1
    nn = [nn nn];
end

[x,y] = meshgrid(-nn(2):nn(2),-nn(1):nn(1));
p = angle(x+1i*y);
r = sqrt(x.^2+y.^2);
rho = rho/pixel;
ex = sin(al)*(interp1(rho,fxx0,r,'pchip')+cos(2*(p-be)).*interp1(rho,fxx2,r,'pchip'))+cos(al)*cos(p-be).*interp1(rho,fxz,r,'pchip');
by = sin(al)*(interp1(rho,byx0,r,'pchip')+cos(2*(p-be)).*interp1(rho,byx2,r,'pchip'))+cos(al)*cos(p-be).*interp1(rho,byz,r,'pchip');
ey = sin(al)*sin(2*(p-be)).*interp1(rho,fxx2,r,'pchip')+cos(al)*sin(p-be).*interp1(rho,fxz,r,'pchip');
bx = -(sin(al)*sin(2*(p-be)).*interp1(rho,byx2,r,'pchip')+cos(al)*sin(p-be).*interp1(rho,byz,r,'pchip'));
tmp = ex*cos(be)-ey*sin(be);
ey = ey*cos(be)+ex*sin(be);
ex = tmp;
tmp = by*cos(be)+bx*sin(be);
bx = bx*cos(be)-by*sin(be);
by = tmp;
int = real(ex.*conj(by) - ey.*conj(bx));
% a=2;