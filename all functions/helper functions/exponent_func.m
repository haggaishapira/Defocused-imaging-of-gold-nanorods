function y = exponent_func(params,x_grid) %% Outputs an elliptical, rotated, 2D Gaussian


a = params(1);
b = params(2);
y0 = params(3);

y = a*exp(b*x_grid);






