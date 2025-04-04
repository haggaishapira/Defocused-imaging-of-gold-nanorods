function params = fit_exponent(y)

    min_lambda = 0.1;
    max_lambda = 100;

    lb = [min_lambda];
    ub = [max_lambda];
    
    optFunc = @two_binned_gaussians;
    options = optimset('lsqcurvefit');
    options = optimset(options, 'Jacobian','off', 'Display','off',  'TolX',10^-2, 'TolFun',10^-2, 'MaxPCGIter',1, 'MaxIter',500);

    x_axis = 0:0.1; 
        
    [paramsFit, ~] = lsqcurvefit(... 
              optFunc, ... % Function to optimize
              initialguess, x_axis, y,... % p0, xdata, ydata
              lb, ub, options); % params: [x0, y0, sx, sy, background, amplitude]

