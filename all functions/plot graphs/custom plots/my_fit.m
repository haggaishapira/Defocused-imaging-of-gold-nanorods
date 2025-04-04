function my_fit(ax,x,y)


    % y = y0 + (y1 - y0) * exp(-k*t)
%     t_trace',fraction_immobile
%     x0 = [0.2 0.7 0.01]; 
%     x0 = [0 1 0.01]; 
    x0 = [0.01]; 
%     fitfun = fittype( @(y0,y1,k,x) y0 + (y1 - y0) * exp(-k * x));
    fitfun = fittype( @(k,x) 1 - exp(-k * x));
    [fitted_curve,gof] = fit(x,y,fitfun,'StartPoint',x0);
    % Save the coeffiecient values for a,b,c and d in a vector
    coeffvals = coeffvalues(fitted_curve);

%     clc
%     y0 = coeffvals(1);
%     y1 = coeffvals(2);
%     k = coeffvals(3);

    k = coeffvals(1);


%     disp(k);
    tau = 1/k;
    fprintf('k: %.3f\n',k);
    fprintf('tau: %.3f\n',tau);

%     str = sprintf('y0: %.3f\ny1: %.3f\nk: %.3f\n',y0,y1,k);
%     str = sprintf('k: %.3f\n',k);
%     fprintf('y0: %.3f\ny1: %.3f\nk: %.3f\n',y0,y1,k);
%     text(x(round(end/2)),0.5,str,'Color','red','FontSize',16,'FontWeight','bold');
  
    % Plot results
%     f2=figure
    hold(ax,'on')
%     plot(ax, x, y,);
%     hold on
%     plot(x,fitted_curve(x),'Color','Red','LineWidth',1);
    plot(x,fitted_curve(x),'LineWidth',2)
%     hold off









