function plot_info = plot_trace_single_molecule(handles,plot_info)    



    old_plot_type = plot_info.current_plots{1};
    new_plot_type = plot_info.new_plots{1};
    init_plot = ~strcmp(old_plot_type,new_plot_type);

    if plot_info.num_mol_curr == 0 && ~strcmp(new_plot_type,'TIRF ensemble - FRET')
        return;
    end
    if plot_info.num_mol_curr > 0
        disp_mol = plot_info.disp_mol;
    end

    first_frame = plot_info.first_frame;
    last_frame = plot_info.last_frame;
    first_t = plot_info.first_t;
    last_t = plot_info.last_t;
    curr_t = plot_info.curr_t;
    

    t = plot_info.analysis.t;
    curr_frame = plot_info.curr_frame;  
    vid_len = plot_info.vid_len;

    acquisition = plot_info.acquisition;
    sequence_info = plot_info.sequence_info;
    analysis = plot_info.analysis;
    settings = handles.extra_calculations_settings;
    
%     t = t / 60;
%     curr_t = curr_t/60;


    if plot_info.hour_scale
        factor = 3600;
%         factor = 3600 * 24;
        t = t / factor;
        curr_t = curr_t/factor;
        sequence_info.time_intervals = sequence_info.time_intervals / factor;
        first_t = first_t / factor;
        last_t = last_t / factor;
    else
        factor = 1;
    end

    t_subtract = 0;
    t_subtract = first_t;

    delta_subtract = 0;

    switch new_plot_type
        case 'phi'
%             y_label = '\phi (°)';
%             y_label = '\phi (# of full rotations)';
            phi = disp_mol.trace_phi_whole(first_frame:last_frame);
            
            % generate random walk
%             phi = zeros(length(phi),1);
%             for i=2:length(phi)
%                 phi(i) = phi(i-1) + 5 * sign(rand() - 0.5);
%             end

            %%% try to smooth the trace from real rotor jumps %%%
%             phi = smooth_phi(phi,sequence_info,analysis);

%             phi = disp_mol.trace_phi_half(first_frame:last_frame);
            y = phi;
            y = double(y);

            delta_subtract = double(disp_mol.trace_phi_whole(10));
%             delta_subtract = 0;
%             delta_subtract = y(10);
%             delta_subtract = y(1) - 10;
%             delta_subtract = 640;
%             delta_subtract = 0;
            y = y - delta_subtract;
            y_label = '\phi (°)';
            

%             y= y - double(disp_mol.trace_phi_whole(1));

            % phi
%             y_lim = [floor(min(y)) - 10 ceil(max(y)) + 10];
%             y_lim = [-40 400];
%             y_lim = [-15 375];
%             y_lim = [-15 160];
%             y_tick = -36000:2*360:36000;
%             y_tick = -0:30:360;

%             t_cycle = (26*8)/60;
%             x_tick = 0:t_cycle:50;
%             handles.ax_trace_sm.XAxis.TickLabelFormat = 'auto';
%             handles.ax_trace_sm.XAxis.TickLabelFormat = '%.0d';

%             x_tick = 0:1:10;

            revolutions = 0;
            if revolutions
                % revolutions
                y_tick = -40:2:20;
    %             x_tick = 0:0.01:100;
%                 x_tick = 0:5.2:100;
                y = y / 360;
%                 num_rev = 6;
%                 y_lim = [0 num_rev];
%                 y_lim = [-30 5];
    %             x_lim = [0 5.2*num_rev];
    
                y_label = '\phi (revolutions)';

            else
                y_lim = [floor((min(y))) ceil((max(y))) ];
            end

%             y_lim = [min(y) ceil((max(y))) + 70];
            y_lim = [min(y) - 1 ceil((max(y))) + 1];
%             y_lim = [min(y) max(y)];
%             y_lim = [0 5];
%             x_tick = 0:5.2:100;
%             y_tick = -36000:360 * 1:36000;
%             y_tick = -36000:180 * 1:36000;
%             y_tick = 0:15:360;

%             y_lim = [-15 440];
%             y_lim = [-15 155];

%             y_lim = [-720 360*1];
%             y_lim = [-15 449];
%             y_lim = [-15 375];

            % plot here the full graph
%             plot_phi_many_molecules(plot_info,t,first_frame,last_frame);


        case 'phi (relative)'
            y_label = 'cumul. angle (°)';
            phi = disp_mol.trace_phi_whole_rel_FH12(first_frame:last_frame);
            y = phi;
            y = double(y);
%             y = mod(y,180);
%             y = y - 360;
%             y = y + 8;
%             y = smooth(y,100);
            y_lim = [floor(min(y)) ceil(max(y))];
%             y_lim = [-30 30];
            if y_lim(2) - y_lim(1) <= 30
                y_lim(2) = y_lim(2) + 40;
                y_lim(1) = y_lim(1) - 40;
            end
%             y_lim = [-15 390];
        case 'defocus'
            y = disp_mol.defocus(first_frame:last_frame);
            y_label = 'defocus (μm)';
            y_lim = [-1.5 0];
        case 'stuck'
            y_label = 'stuck';
            stuck = disp_mol.stuck_trace(first_frame:last_frame);
%             free = 1 - stuck;
            y = stuck;
            y = double(y);
            y_lim = [floor(min(y)) ceil(max(y))];
        case 'free'
            y_label = 'free';
            stuck = disp_mol.stuck_trace(first_frame:last_frame);
            free = 1 - stuck;
            y = free;
            y = double(y);
            y_lim = [floor(min(y)) ceil(max(y))];
        case 'phi (180)'
            y = disp_mol.phi_half(first_frame:last_frame);  
            y = y - disp_mol.FH12_position;
            y = y + plot_info.delta_phi;
            y = mod(y,180);

%             len = length(y);
%             seg = y(1:round(len*1/6));
%             seg(seg>90) = seg(seg>90) - 180;
%             y(1:round(len*1/6)) = seg;
% 
%             seg = y(round(len*5/6):end);
%             seg(seg<90) = seg(seg<90) + 180;
%             y(round(len*5/6):end) = seg;

            y_label = '\phi (°)';  
            y_lim = [0 180];
%             y_lim = [-90 270];
%             y_lim = [50 150];
            y_tick = 0:30:180; 

%             x_tick = 0:3.4667:30; 
            

        case 'd(phi)'
            y_label = '|d(\phi)| (°)';
            y = disp_mol.d_phi(first_frame:last_frame);
            y_lim = [0 150];
%             y_lim = [0 70];
        case 'on'
            y_label = 'on';
            y = disp_mol.on_trace(first_frame:last_frame);
            y_lim = [-0.5 1.5];
        case 'phi half'
            y = disp_mol.phi_half(first_frame:last_frame); 
            y = y + plot_info.delta_phi;
%             y = y + 30;
            y = mod(y,360);
            y_label = '\phi (°)';  
            y_lim = [0 360];
            y_tick = 0:90:360;
        case 'theta'
%             y = disp_mol.theta_whole(first_frame:last_frame);
            y = disp_mol.theta_half(first_frame:last_frame);
            y_lim = [0 90];
            y_label = '\theta (°)';
            y_tick = [0,30,60,90,120,150,180];            
        case 'intensity'
%             y = disp_mol.back(first_frame:last_frame) + disp_mol.int(first_frame:last_frame);
            y = disp_mol.int(first_frame:last_frame);
            y_label = 'I';
            y_lim = [0 max(y)];
        case 'background'
            y = disp_mol.back(first_frame:last_frame);
%             y = displayed_molecule.int(1:last);
            y_label = 'background';
            y_lim = [0 max(y)];
        case 'x'
            y = disp_mol.x(first_frame:last_frame);
            y = y - y(1);
            y_label = 'x (pixels)';
            diff = max(y) - min(y);
            diff = max(5,diff);
            y_lim = [min(y) - diff*0.2 max(y) + diff*0.2];
        case 'y'
            y = disp_mol.y(first_frame:last_frame);
            y = y - y(1);
%             x_fake = disp_mol.x(first_frame:last_frame);
%             figure
%             scatter(x_fake-x_fake(1),y-y(1));

            y_label = 'x (pixels)';
            diff = max(y) - min(y);
            diff = max(5,diff);
            y_lim = [min(y) - diff*0.2 max(y) + diff*0.2];
        case 'lst sq error'
            y = disp_mol.lst_sq_video(first_frame:last_frame);
            y_label = 'lst sq error';
            y_lim = [0 max(y)];
        case 'TIRF ensemble - FRET'
            y = analysis.trace_FRET(first_frame:last_frame);
            y_label = 'FRET';    
            y_lim = [0 1];
        case 'fuel response - F AF'
            y = analysis.trace_FRET(first_frame:last_frame);
            ratio_trace = get_fuel_response_trace(disp_mol,first_t,last_t);
            f1=figure;
            ax = axes(f1);
            plot(ax,ratio_trace);
            ax.YLim = [-1 1];

            y_label = 'fuel response';    
            y_lim = [0 1];
        case 'fuel response - walking'
            y = analysis.trace_FRET(first_frame:last_frame);
            y_label = 'FRET';    
            y_lim = [0 1];

    end
    
    if acquisition
        y = y(1:curr_frame);
        t = t(1:curr_frame);
    else
        t = t';
    end 

%     y = y(1:plot_info.vid_len);
    
    if isempty(y)
        y = 0;
    end
    if init_plot
        cla(handles.ax_trace_sm);
        1;
        % text
%         command_name = sprintf('molecule %d',disp_mol.real_num);
%         text_x = 0;
%         text_y = y_lim(2) + (y_lim(2)-y_lim(1))*0.2;
%         hold(handles.ax_trace_sm,'on');
%         plot_info.sm_text = text(handles.ax_trace_sm,text_x,text_y,command_name,'Rotation',60,'FontSize',6);
%         plot_info.sm_text.Color = col;

        set(handles.ax_trace_sm,'XTickMode','auto','XlimMode','auto','YTickMode','auto','YlimMode','auto');
%         set(handles.ax_trace_sm,'XlimMode','auto','YlimMode','auto');
%         set(handles.ax_trace_sm,'XlimMode','auto');
%         set(handles.ax_trace_sm,'XTickMode','auto','XlimMode','auto','YTickMode','auto');
    
        
        t_use = t(first_frame:last_frame);
        t_use = t_use - t_subtract;

%         plot_info.sm_plot = plot(handles.ax_trace_sm,t_use,y,'LineWidth',2);
        plot_info.sm_plot = plot(handles.ax_trace_sm,t_use,y,'LineWidth',2);

        % interval = 1;
        % plot_info.sm_plot = plot(handles.ax_trace_sm,t_use(first_frame:interval:last_frame),y(1:interval:end),'LineWidth',2);


        % remove scientific notation
        handles.ax_trace_sm.XAxis.Exponent = 0;
%         handles.ax_trace_sm.XTickformat = '%.0f';

%         plot_info.sm_plot = plot(handles.ax_trace_sm,t(first_frame:last_frame),y,'LineWidth',1);
%         plot_info.sm_plot = plot(handles.ax_trace_sm,t,y,'LineWidth',0.5);
        
%         font_size_axes = 32;
        font_size_axes = 14; % alternating
%         font_size_axes = 24;
        handles.ax_trace_sm.FontSize = font_size_axes;
        handles.ax_trace_sm.FontWeight = 'bold';
        if plot_info.hour_scale
            handles.ax_trace_sm.XLabel.String = 'Time (h)';
%             handles.ax_trace_sm.XLabel.String = 'Time (days)';
        else
            handles.ax_trace_sm.XLabel.String = 'Time (s)';
        end
%         handles.ax_trace_sm.XLabel.String = 't (min)';
        handles.ax_trace_sm.YLabel.String = y_label;
        handles.ax_trace_sm.YGrid = 'on';
%         handles.ax_trace_sm.YLabel.Position(1) = handles.ax_trace_sm.YLabel.Position(1)*0.90;
%         disp(handles.ax_trace_sm.YLabel.Position(1));
        

%         handles.ax_trace_sm.YTick = -10000:360:4000;
%         handles.ax_trace_sm.YTick = 0:180:3600;
%         handles.ax_trace_sm.YTick = 0:15:90;
%         handles.ax_trace_sm.YTick = -3600:90:3600;
%         handles.ax_trace_sm.YTick = -0:1:8;
%         handles.ax_trace_sm.YLim = [0 4];
%         handles.ax_trace_sm.YTickLabels = -2:0.5:5;
%         yticklabels("")
        set(handles.ax_trace_sm,'XGrid','on');
%         set(handles.ax_trace_sm,'XGrid','off');
%         handles.ax_trace_sm.XTick = 0:200:1500;
%         handles.ax_trace_sm.XAxis.TickLabelFormat = '%.1f';
        if exist('y_lim','var')
            handles.ax_trace_sm.YLim = y_lim;
        end
        if exist('x_lim','var')
            handles.ax_trace_sm.XLim = x_lim;
        end
        if exist('x_tick','var')
            handles.ax_trace_sm.XTick = x_tick;
            handles.ax_trace_sm.XAxis.TickLabelFormat = '%.1g';
        end
        if exist('y_tick','var')
            handles.ax_trace_sm.YTick = y_tick;
        end

        if y_lim(1)<y_lim(2)
            handles.ax_trace_sm.YLim = y_lim;
        end
        
        % title
%         text_x = 0;
%         text_y = y_lim(2) + (y_lim(2)-y_lim(1))*0.2;
%         handles.ax_trace_sm.Title.String = disp_mol.str;
%         handles.ax_trace_sm.Title.Position = [text_x text_y + 200];
%         handles.ax_trace_sm.Title.FontSize = 12;
        
%     handles.ax_trace_sm.FontSize = 10;

        handles.ax_trace_sm.Title.String = '';

        hold(handles.ax_trace_sm,'on');

        if ~acquisition
            hold(handles.ax_trace_sm,'on');
            plot_info.sm_line_t = line(handles.ax_trace_sm,[curr_t curr_t],handles.ax_trace_sm.YLim,...
                'Linewidth',2,'Color','Black');
            if t(first_frame)<t(last_frame) && ~exist('x_lim','var')
%                 set(handles.ax_trace_sm,'XLim', [t(first_frame) t(last_frame)]);
                set(handles.ax_trace_sm,'XLim', [t_use(1) t_use(end)]);
            end
            plot_info.sm_line_t.Visible = 'off';
        end

        % line first
        handles.ax_trace_sm.Children = flipud(handles.ax_trace_sm.Children);

%         set(handles.ax_trace_sm,'XLim', [min(t) max(t)]);

        % plot commmand sequence

        if plot_info.hour_scale
        end
%         y_lim = handles.ax_trace_sm.YLim;
        if plot_info.plot_sequence
            plot_info.sm_sequence_rectangles = [];
%             counter_fuel_times = 1;
            counter_anti_fuel_times = 1;
            for i=1:sequence_info.total_num_steps
                interval = sequence_info.time_intervals(i,:);
                if interval(1)>vid_len && ~plot_info.hour_scale || interval(1)>last_t || interval(1)<first_t
                    continue;
                end
                interval = interval - t_subtract;
                fuel_group = get_fuel_group();
                anti_fuel_group = get_anti_fuel_group();
                % plot command rectangle
                w = interval(2)-interval(1);
                h = y_lim(2)-y_lim(1);
                col = plot_info.command_colors(i,:);
                if w == 30
                    col = [0.5 0.5 0.5 0.2];
                end

%                 interval = interval - t(first_frame);
                rec = rectangle(handles.ax_trace_sm,'Position',[interval(1) y_lim(1) w h], 'FaceColor', col);
                plot_info.sm_sequence_rectangles = [plot_info.sm_sequence_rectangles; rec];
                hold(handles.ax_trace_sm,'on');
                % text
                command_name = sequence_info.command_names_full_sequence{i};
                if i+1 <= sequence_info.total_num_steps && strcmp(command_name,sequence_info.command_names_full_sequence{i+1})
                    command_name = '';
                end
                if strcmp(command_name,'102')
                    % command_name = 'buffer';
                    command_name = '';
                end
                if strcmp(command_name,'NaCl 1M')
                    command_name = 'high conc.';
                end
                if strcmp(command_name,'AF2 1uM')
                    command_name = 'low conc.';
%                     col = [0.5 0.5 0.5 0.2];
%                     rec.FaceColor(1:4) = col;
                end


%                 if strcmp(command_name,'102')
%                     command_name = 'wash';
%                 end
%                 text_x = interval(1)+(interval(2)-interval(1))*0.2;
%                 text_x = interval(1)+(interval(2)-interval(1));
%                 text_x = (interval(1)+interval(2))*0.4;

                text_x = (interval(1)+interval(2)) * 0.5;
%                   text_x = text_x + 0.05;
%                 text_x = 63320;

%                 val = sequence_info.time_intervals(min(i+1,sequence_info.total_num_steps),2);
%                 val = val - t_subtract;
%                 text_x = mean([interval(1) val]);

            
%                 text_x = interval(1)+(val-interval(1)) * 0.3;
                
                
%                 text_y = y_lim(2) + (y_lim(2)-y_lim(1))*0.03;
                hold(handles.ax_trace_sm,'on');
                
                font_size_commands = font_size_axes;
% %                 font_size_commands = 20;
%                 font_size_commands = 8;
%                 add_x = 20;
%                 if plot_info.hour_scale
%                     add_x = add_x / 3600;
%                 end
%                 text_x = (interval(1) + interval(2))/2;
                text_y = y_lim(2) + (y_lim(2)-y_lim(1))*0.05;
%                 text_y = y_lim(2) + (y_lim(2)-y_lim(1))*0.03;
%                 text_y = y_lim(2) + (y_lim(2)-y_lim(1))*0.04;

%                 plot_info.sm_text = text(handles.ax_trace_sm,text_x,text_y,command_name,'Rotation',60,'FontSize',12,'FontWeight','bold');
                plot_info.sm_text = text(handles.ax_trace_sm,text_x,text_y,command_name,'Rotation',60,'FontSize',font_size_commands,'FontWeight','bold');
%                 plot_info.sm_text = text(handles.ax_trace_sm,text_x,text_y*1.05,command_name,'Rotation',0,'FontSize',font_size_commands,'FontWeight','bold','HorizontalAlignment','center');
                plot_info.sm_text.Color = col;
               
            end
        end
%         text(handles.ax_trace_sm,curr_t,y_lim(2)-5,sprintf('AF%d',mod(i-1,6)+1),'Color','green');

        % plot immobilization time
        if handles.plot_immobilization_time.Value
%             is_fuel = ismember(command_name,fuel_group);
    
            for i=1:length(disp_mol.immobilization_reactions)
                immob_reaction = disp_mol.immobilization_reactions(i);
                final_phi = immob_reaction.final_phi;
                text_phi = mod(final_phi,180);
                if text_phi > 90
                    text_phi = text_phi - 60;
                else
                    text_phi = text_phi + 25;
                end
                imm_time = immob_reaction.immobilization_time;
                if imm_time>first_t && imm_time<last_t
                    imm_time = imm_time - t_subtract;
                    rel_imm_time = immob_reaction.relative_immobilization_time;
                    rel_imm_time = max(rel_imm_time,0);
                    if ~isinf(imm_time)
                        hold(handles.ax_trace_sm,'on');
                        line(handles.ax_trace_sm,[imm_time imm_time],handles.ax_trace_sm.YLim,...
                                'Linewidth',2,'Color','Green');
                        % text
%                         text_x = imm_time + (interval(2) - imm_time)*0.33;
                        text_x = imm_time;
                        text_y = y_lim(2) - (y_lim(2)-y_lim(1))*0.5;
%                         text_y = text_phi;
                        plot_info.sm_text = text...
                            (handles.ax_trace_sm,text_x,text_y,sprintf('%.0f s',rel_imm_time),'Rotation',60,'FontSize',14,'FontWeight','bold');
                        plot_info.sm_text.Color = [0 0 0];
%                         plot_info.sm_text.Color = [0 1 0];

                        plot_info.sm_text.Clipping = 'on';
                        plot_info.sm_text.BackgroundColor = 'White';
%                         plot_info.sm_text.BackgroundColor = 'Black';
                        plot_info.sm_text.Margin = 0.1;
                    end
                end
                1;
            end
        end
    






        % plot immobilization time
        if handles.plot_release_time.Value
%             is_fuel = ismember(command_name,fuel_group);
    
            for i=1:length(disp_mol.release_reactions)
                release_reaction = disp_mol.release_reactions(i);
                initial_phi = release_reaction.initial_phi;
                text_phi = mod(initial_phi,180);
                if text_phi > 90
                    text_phi = text_phi - 60;
                else
                    text_phi = text_phi + 25;
                end
                rel_time = release_reaction.release_time;
                if rel_time>first_t && rel_time<last_t
                    rel_time = rel_time - t_subtract;
                    rel_rel_time = release_reaction.relative_release_time;
                    rel_rel_time = max(rel_rel_time,0);
                    if ~isinf(rel_time)
                        hold(handles.ax_trace_sm,'on');
                        line(handles.ax_trace_sm,[rel_time rel_time],handles.ax_trace_sm.YLim,...
                                'Linewidth',2,'Color','Red');
                        % text
%                         text_x = imm_time + (interval(2) - imm_time)*0.33;
                        text_x = rel_time;
                        text_y = y_lim(2) - (y_lim(2)-y_lim(1))*0.5;
%                         text_y = text_phi;
                        plot_info.sm_text = text...
                            (handles.ax_trace_sm,text_x,text_y,sprintf('%.0f s',rel_rel_time),'Rotation',60,'FontSize',14,'FontWeight','bold');
                        plot_info.sm_text.Color = [0 0 0];
%                         plot_info.sm_text.Color = [1 0 0];
                        plot_info.sm_text.Clipping = 'on';
                        plot_info.sm_text.BackgroundColor = 'White';
                        plot_info.sm_text.Margin = 0.1;
                    end
                end
                1;
            end
        end









%         if handles.plot_release_time.Value
% 
%         % plot release time
%         is_anti_fuel = ismember(command_name,anti_fuel_group);
%         if handles.plot_release_time.Value && is_anti_fuel                     
%            
%             reaction = disp_mol.release_reactions(counter_anti_fuel_times);
%             AF_num = settings.AF_to_show;
%             if AF_num == 0
%                 AF_num = 1:6;
%             end
%             filtered_reaction = get_release_reactions_specific_anti_fuel_and_time(reaction,AF_num,first_t,last_t);
%     
%             plot_now = 1;
%     %                     plot_now = ~mod(counter_anti_fuel_times-(5),6);
%     
%             rel_time = reaction.release_time;
%             rel_rel_time = reaction.relative_release_time;
%             counter_anti_fuel_times = counter_anti_fuel_times + 1;
%             if isempty(filtered_reaction)
% %                 continue;
%             end
%            
%             if plot_now && ~isinf(rel_time)
%                 hold(handles.ax_trace_sm,'on');
%                 line(handles.ax_trace_sm,[rel_time rel_time],handles.ax_trace_sm.YLim,...
%                         'Linewidth',2,'Color','Red');
%                 % text
%                 text_x = rel_time + (interval(2) - rel_time)*0.33;
%                 text_y = y_lim(2) - (y_lim(2)-y_lim(1))*0.5;
%                 plot_info.sm_text = text...
%                     (handles.ax_trace_sm,text_x,text_y,sprintf('%.0f sec',rel_rel_time),'Rotation',60,'FontSize',10,'FontWeight','bold');
%                 plot_info.sm_text.Color = [0 0 0];
%                 plot_info.sm_text.Clipping = 'on';
%     %                         plot_info.sm_text.Color = [1 0 0];
%             end
%         end

        handles.ax_trace_sm.GridAlpha = 0.5;




%         plot dissociation time
%         rel_time = disp_mol.dissociation_time;
%         line(handles.ax_trace_sm,[rel_time rel_time],handles.ax_trace_sm.YLim,...
%                 'Linewidth',2,'Color','Red');

        handles.ax_trace_sm.Children = flipud(handles.ax_trace_sm.Children);

        % reorder stack
%         if handles.plot_fitting.Value
%                 num_recs = length(command_recs);
            all_plots = get(handles.ax_trace_sm,'Children');
            total_num_plots = length(all_plots);
            rec_inds = [];
            text_inds = [];
            line_inds = [];
            plot_inds = [];
            for i=1:total_num_plots
                p = all_plots(i);
                cl = class(p);
                switch cl
                    case 'matlab.graphics.primitive.Rectangle'
                        rec_inds = [rec_inds; i];
                    case 'matlab.graphics.primitive.Text'
                        text_inds = [text_inds; i];
                    case 'matlab.graphics.chart.primitive.Line'
                        plot_inds = [plot_inds; i];
                    case 'matlab.graphics.primitive.Line'
                        line_inds = [line_inds; i];

                end
            end
%             neutral = setdiff(1:total_num_plots,[rec_inds text_inds]);
            new_order = [text_inds' line_inds' plot_inds' rec_inds'];
%                 new_order = [rec_inds' not_recs];
%             t1 = toc;
            new_order_plots = all_plots(new_order);
            set(handles.ax_trace_sm,'Children',new_order_plots);
%             disp(toc-t1);
%         end

            
        if strcmp(new_plot_type,'TIRF ensemble - FRET')
            plot_info.sm_plot.Color = 'Blue';
        end


        %% HMM  
        if handles.plot_hmm_trace.Value
           
            step_reactions = disp_mol.step_reactions;
            anti_fuel_num = settings.AF_to_show;
            if anti_fuel_num == 0
                anti_fuel_num = 1:6;
            end
%             anti_fuel_num = 1:6;
%             anti_fuel_num = 6;
%             anti_fuel_num = 2;
            settings = handles.extra_calculations_settings;
            filtered_step_reactions = filter_step_reactions(step_reactions(:),anti_fuel_num,plot_info.first_t,plot_info.last_t,settings);

            % summarize_step_sizes
            sum_step_sizes = 0;
%             counter = 0;
            for i=1:length(filtered_step_reactions)
                if ~mod(i,2)
%                     continue;
                end
                % plot hmm phi trace
                step_reaction = filtered_step_reactions(i);
                sum_step_sizes = sum_step_sizes + step_reaction.state_2 - step_reaction.state_1;

%                 relative_step_time = step_reaction.relative_step_time;
%                 if relative_step_time < 3 
%                     continue;
%                 end
                hold(handles.ax_trace_sm,'on');
                fitted_trace = step_reaction.fitted_trace;
%                 fitted_trace = fitted_trace + plot_info.delta_phi;

%                 delta_reduce = double(disp_mol.trace_phi_whole(1));
%                 hmm_fitted_trace = hmm_fitted_trace - delta_reduce;
                fitting_t = step_reaction.fitting_t;
                if plot_info.hour_scale
                    fitting_t = fitting_t/3600;
                end

%                 % remember initial phi
%                 if i == 1
%                     initial_phi = step_reaction.initial_phi;
%                 end
%                 final_phi = step_reaction.final_phi;
%                 final_phi = final_phi + plot_info.delta_phi;
% 
% 
%                 if strcmp(new_plot_type,'phi (180)')
%                     fitted_trace = mod(fitted_trace,180);
%                     final_phi = mod(final_phi,180);
%                 end

                fitted_trace = fitted_trace - delta_subtract;
                fitting_t = fitting_t - t_subtract;
                plot(handles.ax_trace_sm,fitting_t,fitted_trace,'LineWidth',2,'Color','Red');
                
    
                % plot step size and time
                % if there is no intermediate then step 1 is already assigned the complete step
                only_plot_last = 1;

                % for showing pattern and error 
%                 global_delta_x = -1300 - t_subtract*factor;
%                 global_delta_y = 70 - delta_subtract;
               
                % for showing pattern and error 2
%                 global_delta_x = -300 - t_subtract*factor;
%                 global_delta_y = 50 - delta_subtract;

                % for 12 steps
%                 global_delta_x = -200 - t_subtract*factor;
                global_delta_x = -400 - t_subtract*factor;
                global_delta_y = 55 - delta_subtract;

%                 if step_reaction.step_size_1 == 76
%                     global_delta_y = global_delta_y + 25;
%                 end

                % normal
%                 global_delta_x = 150 - t_subtract*factor;
%                 global_delta_y = -40 - delta_subtract;

                % for showing one step
%                 global_delta_x = 50 - t_subtract*factor;
%                 global_delta_y = -10 - delta_subtract;

                % delta phi text
                show_delta = 0;
                show_delta  = 1;

                % delta t text
                show_time = 0;
                show_time = 1;
                if show_delta || show_time
                    if ~(step_reaction.intermediate && only_plot_last)
                        txt_1 = '';
                        x_1 = (step_reaction.step_t_1 + global_delta_x)/factor ;
                        y_1 = (step_reaction.state_1 + step_reaction.state_mid)/2 + global_delta_y;
                        if show_delta
                            txt_1 = sprintf('%s%.0f°',txt_1,step_reaction.step_size_1);
                        end
                        if show_delta && show_time
                            txt_1 = sprintf('%s\n',txt_1);
                        end
                        if show_time
        %                     txt_1 = [txt_1 sprintf('%.0f s',step_reaction.relative_step_t_1)];
                            txt_1 = sprintf('%s%.0f s',txt_1,step_reaction.relative_step_t_1);
                        end
                    end
                    if step_reaction.intermediate
                        txt_2 = '';
                        x_2 = (step_reaction.step_t_2 + global_delta_x)/factor ;
                        y_2 = (step_reaction.state_2 + step_reaction.state_mid)/2 + global_delta_y;
                        if show_delta
                            sz = step_reaction.step_size_2;
                            if only_plot_last
                                sz = sz + step_reaction.step_size_1;
                            end
                            txt_2 = sprintf('%s%.0f°',txt_2,sz);
                        end
                        if show_delta && show_time
                            txt_2 = sprintf('%s\n',txt_2);
                        end
                        if show_time
        %                     txt_1 = [txt_1 sprintf('%.0f s',step_reaction.relative_step_t_1)];
                            txt_2 = sprintf('%s%.0f s',txt_2,step_reaction.relative_step_t_2);
                        end
%                         txt_delta_2 = sprintf('%.0f°',sz);
%                         txt_step_t_2 = sprintf('%.0f s',step_reaction.relative_step_t_2);
                    end
    
%                     font_size_hmm = 20;
%                     font_size_hmm = 14;
                    font_size_hmm = 11;
    
                    if ~(step_reaction.intermediate && only_plot_last)
                        txt_1 = text(handles.ax_trace_sm,x_1,y_1,txt_1,'FontSize',font_size_hmm,'FontWeight','bold','Color','Black');
                        txt_1.BackgroundColor = 'White';
                        txt_1.Margin = 0.1;
                    end
                    if step_reaction.intermediate
                        txt_2 = text(handles.ax_trace_sm,x_2,y_2,txt_2,'FontSize',font_size_hmm,'FontWeight','bold','Color','Black');
                        txt_2.BackgroundColor = 'White';
                        txt_2.Margin = 0.1;
                    end
                end
            end
        end

        num_dwells = length(disp_mol.dwells);
        if handles.plot_dwell_times.Value && num_dwells > 0
%             dwell_times = get_data_simple(disp_mol.dwells,'dwell_time');
%             dwell_start_times = get_data_simple(disp_mol.dwells,'start_time');
%             dwell_end_times = get_data_simple(disp_mol.dwells,'end_time');
%             dwell_phis = get_data_simple(disp_mol.dwells,'phi');

            dwell_times = disp_mol.dwells(1,:);
            dwell_start_times = disp_mol.dwells(2,:);
            dwell_end_times = disp_mol.dwells(3,:);
            dwell_phis = disp_mol.dwells(4,:);
            for i=1:num_dwells
                if dwell_start_times(i) < first_t || dwell_end_times(i) > plot_info.last_t
                    continue
                end
                min_dwell_time = 2;
                if dwell_times(i) < min_dwell_time
                    continue;
                end
                x = [dwell_start_times(i) dwell_start_times(i) + dwell_times(i)];
                y = [dwell_phis(i) dwell_phis(i)];
                line(handles.ax_trace_sm,x,y,'Color','Red','LineWidth',1);
                txt = sprintf('%.0f',dwell_times(i));
                text(handles.ax_trace_sm,mean(x),y(1)+50,txt,'FontSize',10,'FontWeight','bold','Color','Black');
            end
        end

    else
        set(plot_info.sm_plot,'XData',t(first_frame:last_frame)-t_subtract,'YData',y);
%         handles.ax_trace_sm.XLim = [curr_t - 100 curr_t + 100];

%         if min(y)~=max(y)

%             handles.ax_trace_sm.YLim = [min(y) max(y)];
%         else
%             handles.ax_trace_sm.YLim = [min(y) max(y)+10];
%         end
        if y_lim(1) ~= y_lim(2)
            handles.ax_trace_sm.YLim = y_lim;
        end
        if ~acquisition
            set(plot_info.sm_line_t,'XData',[curr_t curr_t] - t_subtract,'YData',handles.ax_trace_sm.YLim);
            set(plot_info.sm_line_t,'Visible','on');
        else
%             t1 = toc;
            if plot_info.plot_sequence
%                 xlim = handles.ax_trace_sm.XLim;
                for i=1:length(plot_info.sm_sequence_rectangles)
%                     if xlim(1) <= sequence_info.time_intervals(i,1) && xlim(2) >= sequence_info.time_intervals(i,2)
                        rec = plot_info.sm_sequence_rectangles(i);
                        rec.Position(2) = y_lim(1);
                        rec.Position(4) = y_lim(2) - y_lim(1);
%                     end
                end
            end
%             t2 = toc-t1;
%             disp(t2);
        end
        if acquisition && min(t)<curr_t
            set(handles.ax_trace_sm,'XLim', [first_t curr_t]);
        end
    end
    

    
%     t3 = toc;
    
