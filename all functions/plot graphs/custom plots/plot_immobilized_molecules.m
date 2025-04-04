function handles = plot_immobilized_molecules(handles,plot_info)

    analysis = plot_info.analysis;
    curr_frame = plot_info.curr_frame;

    all_positions_trace = analysis.all_positions_trace;
    uncrowded_positions_trace = analysis.uncrowded_positions_trace;

    
    all_positions = all_positions_trace{curr_frame};
    uncrowded_positions = uncrowded_positions_trace{curr_frame};
    
    delete(handles.all_immobilized_mol_plot);
    delete(handles.uncrowded_immobilized_mol_plot);

    hold(handles.ax_video,'on');
%         delete(p);

    if ~isempty(all_positions)
        handles.all_immobilized_mol_plot = plot(handles.ax_video,all_positions(:,1),all_positions(:,2),'.','color','red');
        hold(handles.ax_video,'on');
        handles.uncrowded_immobilized_mol_plot = plot(handles.ax_video,uncrowded_positions(:,1),uncrowded_positions(:,2),'.','color','green');
        
    end
    
    