function handles = initialize_polar_axes(handles)
    
%     factor = 1.7;
%     handles.ax_hist_polar = polaraxes(handles.figure1,...
%                         'Position',[0.76 0.531 0.157*factor 0.144*factor]);

    % make smaller
    factor = 1.3;
    handles.ax_hist_polar = polaraxes(handles.figure1,...
                        'Position',[0.78 0.531 0.157*factor 0.144*factor]);


    handles.ax_hist_polar.FontSize = 14;
    handles.ax_hist_polar.FontWeight = 'bold';
