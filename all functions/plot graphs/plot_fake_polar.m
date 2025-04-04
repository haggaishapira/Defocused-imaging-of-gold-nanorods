function handles = plot_fake_polar(handles, phi_deg, theta_avg_per_phi)

    
    phi_rad = (-phi_deg + 90) * 2 * pi/360;
    n = 25;
%     colours = hsv(n);
%     colours(1,:) = [0 0 0];
    col1 = [1 0 0];
    col2 = 0.9 * [1 1 1];
    handles.ax_hist_fake_polar.FontSize = 20;

    rose(handles.ax_hist_fake_polar,phi_rad),cla %Use this to initialise polar axes
%             cla(handles.ax_hist_fake_polar);
    [phi,rho] = rose(handles.ax_hist_fake_polar,phi_rad,n); % Get the histogram edges
    handles.ax_hist_fake_polar.FontWeight = 'bold';
    handles.ax_hist_fake_polar.FontSize = 20;
%     rho = rho/200;
    phi(end+1) = phi(1); % Wrap around for easy interation
    rho(end+1) = rho(1); 
    hold on;
    fac_bin = 4;
    for j = 1:floor(length(phi)/fac_bin)
    % for j = 1
        k = @(j) fac_bin*(j-1)+1; % Change of iterator
        h = polar(handles.ax_hist_fake_polar,phi(k(j):k(j)+fac_bin-1),rho(k(j):k(j)+fac_bin-1));
%         set(h,'color',colours(j,:)); % Set the color
        phi_ind = phi_deg(k(j))/5 + 1;
        try 
            theta_avg = theta_avg_per_phi(phi_ind);
        catch e
            1;
        end
        if isnan(theta_avg)
            theta_avg = 0;
        end
%         factor = (90-theta_avg) / 90;
        factor = (90-theta_avg)/ 40;
%         disp(theta_avg);
        col = col1 .* factor + col2 .* (1-factor);
%         disp(col);
        set(h,'color', col); % Set the color
        [x,y] = pol2cart(phi(k(j):k(j)+fac_bin-1),rho(k(j):k(j)+fac_bin-1));
        h = patch(x,y,'');
%         set(h,'FaceColor',colours(j,:),'FaceAlpha',1);
        set(h,'FaceAlpha',1);
        set(h,'FaceColor',col);
        uistack(h,'down');
    end
%     grid on; 
%     grid on; axis equal;
    title('phi distribution (color=avg theta)');
    handles.ax_hist_fake_polar.FontWeight = 'bold';
    handles.ax_hist_fake_polar.FontSize = 12;
