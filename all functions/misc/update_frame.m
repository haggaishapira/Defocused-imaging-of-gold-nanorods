function frame = update_frame(handles,num)
    frame = get_frame(handles,num,1);
%     handles.frame = frame;

%     disp(max(frame(:)));


    show_frame(handles,frame);
