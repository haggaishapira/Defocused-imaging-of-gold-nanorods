function [ROIs,num_mol] = select_ROIs_manually(handles)

    [x,y] = getpts(handles.ax_video);
    num_mol = length(x);
    for i = 1:num_mol
%             ROI = imrect(handles.ax_video);
        ROI = [x(i)-nn y(i)-nn ROI_dim ROI_dim];
        ROI = round(ROI);
        ROIs = [ROIs ROI'];      
    end       