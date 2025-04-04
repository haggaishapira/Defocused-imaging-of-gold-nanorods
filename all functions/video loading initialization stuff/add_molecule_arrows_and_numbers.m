function [analysis,all_lines,all_lines_reference] = add_molecule_arrows_and_numbers(handles, analysis, initial_ROI)

%     num_mol = size(molecules,2);
    num_mol = analysis.num_mol;
%     handles.all_lines = [];
    current_frame = round(handles.slider_frames.Value);
%     add_reference_state_arrow = handles.toggle_reference_state_arrows.Value;
    add_reference_state_arrow = 1;

    for i=1:num_mol
        color_text = [1 0 0];
%         color_arrow = [0 1 0];
        color_arrow = [1 0 0];
%         color_arrow_reference = [1 0 0];
        color_arrow_reference = [0 1 0];


        visible = handles.toggle_reference_state_arrows.Value;
        if add_reference_state_arrow
            [arrow_main_reference,arrow_right_reference,arrow_left_reference] = add_arrow...
                                (handles,analysis.molecules(i),color_arrow_reference,initial_ROI,visible);
            analysis.molecules(i).arrow_main_reference = arrow_main_reference;
            analysis.molecules(i).arrow_right_reference = arrow_right_reference;
            analysis.molecules(i).arrow_left_reference = arrow_left_reference;
        end   

        visible = handles.toggle_arrows.Value;
        [arrow_main,arrow_right,arrow_left] = add_arrow(handles,analysis.molecules(i),color_arrow,initial_ROI,visible);
        analysis.molecules(i).arrow_main = arrow_main;
        analysis.molecules(i).arrow_right = arrow_right;
        analysis.molecules(i).arrow_left = arrow_left;
     
        
        if initial_ROI
            ROI = analysis.molecules(i).initial_ROI;
        else
            ROI = analysis.molecules(i).ROI(current_frame,:);
        end

        visible = handles.toggle_numbers.Value;
        real_num = analysis.molecules(i).num;
        analysis.molecules(i).text_num = text(handles.ax_video,ROI(1),ROI(2),sprintf('%d',real_num),...
            'color',color_text,...
            'fontweight','bold',...
            'Clipping','on',...
            'Visible',visible);
    end

    pause(0.0001);
    
%         for i=1:num_mol
%             handles.all_lines = [handles.all_lines;...
%                 molecules(i).arrow_main.Edge;...
%                 molecules(i).arrow_right.Edge;...
%                 molecules(i).arrow_left.Edge];
%         end
    all_lines = make_lines_array(analysis.molecules,num_mol);
    all_lines_reference = make_lines_array_reference(analysis.molecules,num_mol);










