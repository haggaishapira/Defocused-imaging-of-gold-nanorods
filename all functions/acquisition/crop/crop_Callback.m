function crop_Callback(hObject, eventdata, handles)


%     choice = menu('Choose crop size','256','128','64','32');
    choice = my_menu('Choose crop size','256','128','64','32');
    if ~(choice)
        return;
    end

    choices = {'256','128','64','32'};

    dim = str2num(choices{choice});

    % correct for binning
    vid_dim_on_crop_selection = size(handles.ax_video.Children(end).CData,1);
    crop_factor = 512/vid_dim_on_crop_selection;
    dim = dim / crop_factor;

%     left = dim-dim/2-1;
%     top = dim-dim/2-1;

    left = 256-dim/2+1;
    top = 256-dim/2+1;


    ROI = [left top dim dim];

    
    handles.crop_handle = drawrectangle(handles.ax_video,'Position',ROI,...
        'Color',[1 0 0],'FaceAlpha',0,'LineWidth',2,'MarkerSize',1);
    handles.crop_handle.InteractionsAllowed = 'translate';

    handles.crop_factor = crop_factor;

    update_handles(handles.figure1,handles);




