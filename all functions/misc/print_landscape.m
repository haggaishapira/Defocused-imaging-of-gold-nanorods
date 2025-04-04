function print_landscape(handles,ROI_image_raw)
    clc
    view = handles.ax_landscape.View;
    
    ROI_image = double(ROI_image_raw);
    patterns = handles.patterns_fitting_flat;
    ROI_image = ROI_image - min(ROI_image(:));
    ROI_image = ROI_image / sum(ROI_image(:));
    [angle,lst_sq, sm_sqs] = fit_pattern_least_squares(ROI_image(:), patterns, 50);
%     disp(angle);
    
    [lsq_theta,lsq_phi] = angle_to_theta_phi(angle,10,5,72);
    handles.theta_disp.String = lsq_theta;
    handles.phi_disp.String = lsq_phi;
    
    
    num_theta = 5;
    num_phi = 72;
    z = reshape(sm_sqs,num_phi,num_theta);
    z = z';
    
    thetas = 50:10:90;
    phis = 0:5:355;
    
    cla(handles.ax_landscape);
    [x,y] = meshgrid(phis,thetas);
    surf(handles.ax_landscape,x,y,z);
    xlabel(handles.ax_landscape, '\phi');
    ylabel(handles.ax_landscape, '\theta');
    zlabel(handles.ax_landscape, 'sum of squares');
    handles.ax_landscape.FontWeight = 'bold';
    handles.ax_landscape.FontSize = 18;
    handles.ax_landscape.XTick = 0:90:360;
    handles.ax_landscape.YTick = 0:10:90;
    handles.ax_landscape.ZLim = [0 0.004];
    handles.ax_landscape.ZTick = 0:0.0005:0.004;
    
%     handles.ax_landscape.View = [-0.7 4.4];
    handles.ax_landscape.View = view;
    hold(handles.ax_landscape, 'on');
    plot3(handles.ax_landscape,1,1,0.0001, 'color', 'red', 'LineWidth', 5);
    
    [hc_theta, hc_phi] = hill_climbing(handles, ROI_image(:));
    
    fprintf('lsq theta: %d. lsq phi: %d\n', lsq_theta, lsq_phi);
    fprintf('hc theta: %d. hc phi: %d\n\n', hc_theta, hc_phi);
