function my_fit_double_exponent(ax,x,y,N)


    % y = y0 + (y1 - y0) * exp(-k*t)
%     t_trace',fraction_immobile
    x0 = [0.7 0.1 0.001]; 
    fitfun = fittype( @(a,k1,k2,x) a * (1 - exp(-k1 * x)) + (1 - a) * (1 - exp(-k2 * x)));
    [fitted_curve,gof] = fit(x,y,fitfun,'StartPoint',x0);
    % Save the coeffiecient values for a,b,c and d in a vector
    coeffvals = coeffvalues(fitted_curve);

%     clc
    a = coeffvals(1);
    k1 = coeffvals(2);
    k2 = coeffvals(3);

    t1 = 1/k1;
    t2 = 1/k2;
%     disp('GOF');
%     disp(gof);

%     str = sprintf('a: %.3f\nk1: %.3f\nk2: %.3f\nN = %d\n',a,k1,k2,N);
%     str = sprintf('a = %.3f\nk1 = %.3f\nk2 = %.3f\n\n',a,k1,k2);
%     str = sprintf('a = %.3f\nt1 = %.3f\nt2 = %.3f\n\n',a,t1,t2);
    str = sprintf('a = %.2f\nt1 = %.1f\nt2 = %.1f\n\n',a,t1,t2);
    fprintf(str,a,k1,k2,N);
    fprintf('\n');
%     text(x(round(end/2)),0.5,str,'Color',[1 0 0],'FontSize',20,'FontWeight','bold');
  
    % Plot results
%     f2=figure
    hold(ax,'on')
%     plot(ax, x, y,);
%     hold on
%     plot(x,fitted_curve(x),'Color','Red','LineWidth',1)
%     plot(x,fitted_curve(x),'LineWidth',2,'Color','red');
    plot(x,fitted_curve(x),'LineWidth',2);
    hold off









