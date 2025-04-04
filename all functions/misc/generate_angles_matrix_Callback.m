function generate_angles_matrix_Callback(hObject, eventdata, handles)

    analysis = get_current_analysis(handles);
    curr_mol = analysis.molecules;
    num_mol_curr = analysis.num_mol;


    if num_mol_curr>0
%         disp_mol_index = handles.molecule_list.Value;
        disp_mol_index = get_disp_mol_index(handles);
        molecule = curr_mol(disp_mol_index); 
    else
        return;
    end

    angle_cells = cell(1,720);

    len = analysis.vid_len;

    thetas = molecule.theta_half;
    phis = molecule.phi_half;

    for j=1:len
        theta = thetas(j);
        phi = phis(j);
%             phi = mod(phi,360);
%             if theta > 90
%                 theta = 180-theta;
%                 phi = mod(phi+180,360);
%             end
        ind = 1 + 72 * theta/10 + phi/5;
%             disp(ind);
        angle_cells{ind} = [angle_cells{ind} j];
    end


    image_matrix = zeros(10*29,72*29);
    for i=1:720
        arr = angle_cells{i};
        if ~isempty(arr)
            frame_num = arr(1);
%             frame = video(:,:,frame_num);
            frame = get_frame(handles,frame_num,1);
            ROI = molecule.ROI(frame_num,:);
            ROI_im = get_integer_pixel_ROI_image(frame,ROI);
%             ROI_im = my_transform_fit_size_2...
%                 (ROI_im,ROI(3),handles.pat_x,ROI(4),handles.pat_y,0,0);   
%                 ROI_im = ROI_im - min(ROI_im(:));
%                     ROI_im = ROI_im/sum(ROI_im(:));
            theta_ind = floor((i-1)/72);
            phi_ind = mod(i-1,72);
            start_theta = 1 + theta_ind*29;
            start_phi = 1 + phi_ind*29;
            image_matrix(start_theta:start_theta+28,start_phi:start_phi+28) = ROI_im;
        end
    end
%         new_image_matrix = zeros(2*10*25,72*25/2);
%         new_image_matrix(1:5*25,:) = image_matrix(1:5*25,1:36*25);
%         new_image_matrix(1+5*25:10*25,:) = image_matrix(1:5*25,1+36*25:72*25);
%         new_image_matrix(1+10*25:15*25,:) = image_matrix(1+5*25:10*25,1:36*25);
%         new_image_matrix(1+15*25:20*25,:) = image_matrix(1+5*25:10*25,1+36*25:72*25);
        f=figure('Position',[10 300 1500 300],'Color',[1 1 1]);
%         colormap(gcf,gray(50));

        vid_lims = handles.ax_video.CLim;
        ax=axes(f);

%         thetas_to_show = 5:end

        imagesc(0:5:355,0:10:90,image_matrix(5:end,:),vid_lims);
%         imagesc(image_matrix,vid_lims);

        colormap(ax,gray(50));

        ax.XLabel.String = 'Phi';
        ax.YLabel.String = 'Theta';














