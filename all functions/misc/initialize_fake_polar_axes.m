function handles = initialize_fake_polar_axes(handles)
    factor = 0.1;
    handles.ax_hist_fake_polar = axes(handles.figure1,...
                        'Position',[0.76 0.531 0.157*factor 0.144*factor]);
    handles.ax_hist_fake_polar.FontSize = 20;
    handles.ax_hist_fake_polar.FontWeight = 'bold';
%     handles.ax_hist_fake_polar.Visible = 'off';
