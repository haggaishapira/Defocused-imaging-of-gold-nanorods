function imgFit = Gauss2D(grid, x0, y0, sx, sy, background, amplitude) %% Outputs an elliptical, rotated, 2D Gaussian
% Rotated 2D elliptical 2D Gaussian
%
%    Input arguments:
%       grid       - [x y] meshgrids
%       x0,y0      - Center coordinates
%       sx,sy      - Gaussian width (x and y std. dev.)
%       theta      - Angle of rotation
%       background - constant offset
%       amplitude  - amplitude factor
%
%    Output arguments:
%    imgFit - Gaussian image (model function)

% Initialize
[sizey sizex] = size(grid);
sizex = sizex/2; % The grid is sent as [x y]
imgFit = zeros(sizey, sizex); % Pre-allocate imgFit

% X and Y grids
x = grid(:,1:sizex);
y = grid(:,sizex+1:end);

% Transform
xprime = (x-x0);
yprime = (y-y0);

% Make 2D Gaussian
p = exp( - ((xprime).^2/(2*sx^2) + (yprime).^2/(2*sy^2) )); % Gaussian
imgFit = amplitude*p + background; % Add amplitud




