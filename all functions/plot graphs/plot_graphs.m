function handles = plot_graphs(handles,acquisition,initialize_all,analysis,change_molecules_visibility)

%     try
        if isempty(analysis) || analysis.empty
            return;
        end
    
        plot_info = initialize_plot_info(handles,acquisition,initialize_all,analysis,handles.plot_info);
    
        immobilization_mode = strcmp(plot_info.analysis.analysis_mode,'immobilization');
        if immobilization_mode
            handles = plot_immobilized_molecules(handles,plot_info);
            plot_trace_ensemble(handles,plot_info);
            return;
        end
    
        if plot_info.num_mol_curr > 0
            if change_molecules_visibility
        %             handles.all_lines = make_lines_array(plot_info.curr_mol,plot_info.num_mol_curr);
                curr_nums = cell2mat({plot_info.curr_mol.num});
            %             all_nums = cell2mat({plot_info.all_curr_mol.num});
                for i=1:plot_info.num_all_mol_curr
                    molecule = plot_info.all_curr_mol(i);
                    num = molecule.num;
                    if ismember(num,curr_nums)
                        str = 'on';
                    else
                        str = 'off';
                    end
                    if handles.toggle_arrows.Value
                        molecule.arrow_main.Edge.Visible = str;
                        molecule.arrow_right.Edge.Visible = str;
                        molecule.arrow_left.Edge.Visible = str;
                    end   
                    if handles.toggle_reference_state_arrows.Value
                        molecule.arrow_main_reference.Edge.Visible = str;
                        molecule.arrow_left_reference.Edge.Visible = str;
                        molecule.arrow_right_reference.Edge.Visible = str;
                    end   
                    if handles.toggle_arrows.Value
                        molecule.ROI_handle.Visible = str;
                    end
                    if handles.toggle_ROIs.Value
                        molecule.text_num.Visible = str;
                    end
                end
            end
    
            if handles.toggle_arrows.Value
                handles = update_arrows(handles,plot_info);
            end
            always_update_reference = 0;
            periodically_update_reference = 1;
            if handles.toggle_reference_state_arrows.Value && ...
                    (plot_info.curr_frame == plot_info.plot_reference_frame_num...
                        ||always_update_reference || ( periodically_update_reference && ~mod(plot_info.curr_frame,100)))
                handles = update_arrows_reference(handles,plot_info);
            end
            ROI_image = update_ROI_image(handles,plot_info);
            update_fitting_pattern(handles,plot_info);
            plot_gold_3d(handles,plot_info);
    
            if handles.toggle_ROI_arrow.Value
                if initialize_all
                    handles = toggle_ROI_arrow(handles);
                end
                handles = update_ROI_arrow(handles,plot_info,ROI_image);
            end    
            if handles.toggle_ROI_arrow_reference.Value
                if initialize_all
                    handles = toggle_ROI_arrow_reference(handles);
                end
                update_ROI_arrow_reference(handles,plot_info,ROI_image);
            end   
    
        end
    
    
        plot_info = plot_trace_single_molecule(handles,plot_info);
        plot_info = plot_trace_ensemble(handles,plot_info);
    
        if plot_info.num_mol_curr>0
            plot_hist_polar(handles,plot_info);
            plot_hist_linear(handles,plot_info);
            plot_output_number(handles,plot_info);
        end
    
        % plot ROI for each step
%         plot_ROI_each_step(handles,plot_info);


    
        handles.current_plots = plot_info.new_plots;
        update_ROI_handles(handles,plot_info);
        handles.plot_info = plot_info;
    
    
    %     disp(toc-t1);

%     catch e
%         disp(e);
%     end













