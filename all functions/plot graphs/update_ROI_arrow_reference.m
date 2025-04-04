function update_ROI_arrow_reference(handles,plot_info,ROI_im)

    curr_mol = plot_info.disp_mol;
%     curr_frame = plot_info.curr_frame;
%     phi = curr_mol.trace_phi_whole(curr_frame);
%     phi = curr_mol.trace_phi_whole(1) - 10;
%     phi = curr_mol.trace_phi_whole(1) - 4000;

%     frame_num = plot_info.plot_reference_frame_num;

%     frame_num = 133333;

%     phi = curr_mol.trace_phi_whole(frame_num);
%     phi = curr_mol.initial_state_phi;
%     phi = curr_mol.final_state_phi;
%     phi = 160;

%     phi = curr_mol.final_state_phi;

%     registered_phi_states = get_registered_states(handles,plot_info.num_all_mol_curr);
%     phi = registered_phi_states(plot_info.disp_mol_index);

    phi = curr_mol.FH12_position;
%     phi = curr_mol.FH12_position + 60;

    XLim = handles.ax_ROI.XLim;
    YLim = handles.ax_ROI.YLim;
    pos = handles.ax_ROI.Position;

%     dim = size(handles.ax_ROI.Children(end).CData)
    dim = size(ROI_im,1);
    ROI = [1 1 dim dim];

    [x_main,y_main,x_right,y_right,x_left,y_left] = get_arrow_coordinates_ROI(ROI,phi,pos,XLim,YLim);

    z = [0 0];
    coords{1} = single([x_main; y_main; z]);
    coords{2} = single([x_right; y_right; z]);
    coords{3} = single([x_left; y_left; z]);               
  
    [handles.lines_ROI_arrow_reference.VertexData] = coords{:};

%     disp(phi);















