function handles = update_arrows(handles,plot_info)

    num_mol = plot_info.num_all_mol_curr;

    XLim = handles.ax_video.XLim;
    YLim = handles.ax_video.YLim;
    pos = handles.ax_video.Position;
    curr_molecules = plot_info.all_curr_mol;
    curr_frame = plot_info.curr_frame;

    for j=1:num_mol
        molecule = curr_molecules(j);
        ROI = molecule.ROI(curr_frame,:);
        phi = molecule.phi_half(curr_frame);
%         phi = mod(phi+180, 360);
%         phi = mod(molecule.trace_phi_whole(curr_frame),360);
%         phi = molecule.phi_whole(curr_frame);
        [x_main,y_main,x_right,y_right,x_left,y_left] = ...
                get_arrow_coordinates(ROI,phi,pos,XLim,YLim);
        z = [0 0];
        if ~isequal(x_main,-1)
            coords_all{j*3-2} = single([x_main; y_main; z]);
            coords_all{j*3-1} = single([x_right; y_right; z]);
            coords_all{j*3} = single([x_left; y_left; z]);               
        end
    end  
    if num_mol>0
        [handles.all_lines.VertexData] = coords_all{:};
    end    
    
    
