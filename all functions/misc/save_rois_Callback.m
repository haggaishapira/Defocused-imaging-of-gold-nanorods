function save_rois_Callback(hObject, eventdata, handles)
    molecules = handles.molecules;
    num_mol = handles.num_mol;
    handles.rois = zeros(4,num_mol);
    for i=1:num_mol
        ROI = molecules(i).ROI(:,1);
        handles.rois(:,i) = ROI;
    end
    msgbox('saved rois');
    update_handles(handles.figure1, handles);
