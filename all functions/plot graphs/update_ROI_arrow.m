function handles = update_ROI_arrow(handles,plot_info,ROI_im)

    curr_mol = plot_info.disp_mol;
    curr_frame = plot_info.curr_frame;
    
%     phi = curr_mol.phi_half(curr_frame);
    phi = curr_mol.trace_phi_whole(curr_frame);
    phi = mod(phi+180,360);

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
  
    [handles.lines_ROI_arrow.VertexData] = coords{:};

%     disp(phi);

