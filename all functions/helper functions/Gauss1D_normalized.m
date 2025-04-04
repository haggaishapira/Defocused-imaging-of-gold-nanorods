function fit = Gauss1D_normalized(x_axis, x0, sx, background, amplitude) 


xprime = (x_axis-x0);

p = exp( - ((xprime).^2/(2*sx^2) )) / (sx * (2*pi)^0.5); 

fit = amplitude*p + background; 




