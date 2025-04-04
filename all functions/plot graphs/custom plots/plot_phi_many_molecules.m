function plot_phi_many_molecules(plot_info,t,first_frame,last_frame)



    f1=figure;
    f1.Position(2) = f1.Position(2) * 0.5;
    ax=axes(f1);
    misc_molecules = plot_info.misc_molecules;
%                 phis = get_data(misc_molecules,plot_info.num_misc_mol,'trace_phi_whole',first_frame,last_frame);
    for i=1:plot_info.num_misc_mol
%                     y_temp = phis(:,i);
        len = length(misc_molecules(i).trace_phi_whole);
        y_temp = double(misc_molecules(i).trace_phi_whole(first_frame:min(last_frame, len)));
        y_temp = y_temp - y_temp(1);
%                     y_temp = y_temp - 20;
%                     y_temp = y_temp + 40;
%                     y_temp = y_temp - double(disp_mol.trace_phi_whole(1));
       
        y_temp = y_temp';
        y_temp = y_temp / 360;
%                     x_temp = misc_molecules(i).t(first_frame:min(last_frame, len));
%         x_temp = t(first_frame:last_frame);
        x_temp = t(first_frame:min(last_frame, len));
        x_temp = x_temp - x_temp(1);
%                     disp(x_temp(1));
%                     x_temp = x_temp - 4.0550e+04;

        x_temp = x_temp / 3600;
        if i == 1 
%             x_temp = x_temp(238331:418559);
%             y_temp = y_temp(238331:418559);
%             x_temp = x_temp(1:333330) + 1;
%             y_temp = y_temp(1:333330);
% 
%             x_temp = x_temp(1:7:499000);
%             y_temp = y_temp(1:7:499000);
% 
%             x_temp = x_temp - x_temp(1);
%             y_temp = y_temp - y_temp(1);
        end
        if i == 2
%                         x_temp = x_temp(1:499000) + 2;
%                         y_temp = y_temp(1:499000);      
%                         y_temp = y_temp - y_temp(1) + 0.1;
        end
        if i == 3
%                         x_temp = x_temp(1:241053);
%                         y_temp = y_temp(1:241053);                        
        end
%                     if i == 4
%                         x_temp = x_temp(23420:275210);
%                         y_temp = y_temp(23420:275210);
%                         x_temp = x_temp - x_temp(1);
%                         y_temp = y_temp - y_temp(1) + 1;
%                     end
%                     plot(ax,x_temp,y_temp,'LineWidth',0.5);
        col = [0, 0.4470, 0.7410];
%                     plot(ax,x_temp,y_temp,'LineWidth',0.5,'Color',col);
%                     plot(ax,x_temp,y_temp,'LineWidth',0.5);
%         plot(ax,x_temp,y_temp,'LineWidth',2);
        plot(ax,x_temp,y_temp,'LineWidth',0.5);
        hold(ax,'on');
    end
    ax.YGrid = 'on';
    ax.XGrid = 'on';
    ax.GridAlpha = 1;
    
%                 ax.XTick = 0:5.333:85;
    ax.XTick = 0:5.2:85;
%                 ax.XTick = (0:5.2:85)*3600;
%                 ax.XTick = 0:(47520/3600):300;
%                 ax.XTick = 0:1560:100000;
    ax.YTick = -20:1:20;
%                 ax.YTick = 0:1:5;
%                 ax.YTick = -1800:180:3600;

%                 ax.YTickLabels = [];
                ax.YLim = [-2 13];
%                 ax.YLim = [0 6];
%                 ax.XLim = [0 131000];
%                 ax.YLim = [0 max(y_temp)];
%                 for i=1:2:30
%                     ax.YTickLabels{i} = '';
%                 end

%                 ax.XAxis.TickLabelFormat = '%.1f';
    ylabel('# of full rotations');
%                 ylabel('\phi (°)');
    xlabel('t (h)');
%                 xlabel('t (sec)');
    ax.FontSize = 14;
    ax.FontWeight = 'bold';
    f1.Color = 'white';
    f1.Position(3) = f1.Position(3) * 1.5; 
    str_cell_arr = {};
    for i=1:plot_info.num_misc_mol
        str_cell_arr{i} = misc_molecules(i).str;
    end
%     l=legend(ax,str_cell_arr);
%     l.Location = 'northeastoutside';




