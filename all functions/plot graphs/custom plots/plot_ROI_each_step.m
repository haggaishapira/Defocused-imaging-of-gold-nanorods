function plot_ROI_each_step(handles,plot_info)


    molecule = plot_info.disp_mol;
%     num_steps = length(molecule.step_reactions);
    sequence_info = plot_info.sequence_info;

    framerate = plot_info.framerate;
    time_intervals = sequence_info.time_intervals;
    start_intervals = time_intervals(:,1);

    num_steps = ceil(sequence_info.total_num_steps/10);
    num_cycles = ceil(num_steps/12);

    % create image
    image_matrix = zeros(num_cycles*29,12*29);

    step_num = 1;
    cycle_num = 1;
    % iterate steps
    first_i = 1;
%     first_i = 41;
    for i=first_i:10:length(start_intervals)
        frame_num = max(1,round(start_intervals(i)*framerate));
        frame_num = frame_num + 30;
        if frame_num > plot_info.last_frame
            break;
        end

        % get single frame
        frame = get_frame(handles,frame_num,0);
        ROI = molecule.ROI(frame_num,:);
        ROI_image = get_integer_pixel_ROI_image(frame,ROI);

        % get average of x frames
%         seg_len = 1;
%         ROI_image = zeros(29,29);
%         for j=frame_num:frame_num + seg_len
%             frame = get_frame(handles,frame_num,0);
%             ROI = molecule.ROI(frame_num,:);
%             ROI_image = ROI_image + get_integer_pixel_ROI_image(frame,ROI);
%         end
%         ROI_image = ROI_image / seg_len;
        
        start_y = 1 + (cycle_num-1)*29;
        start_x = 1 + (step_num-1)*29;
        image_matrix(start_y:start_y+28,start_x:start_x+28) = ROI_image;

        step_num = step_num + 1;        
        if step_num > 12
            step_num = 1;
            cycle_num = cycle_num + 1;
        end
    end

    f=figure('Position',[459   120   853   627],'Color',[1 1 1]);
    vid_lims = handles.ax_video.CLim;
    ax=axes(f);

    % convert to RGB
    RGB_matrix = zeros(29*num_cycles,29*12,3,'uint8');
    image_matrix = uint8(image_matrix / (2^15-1) * (2^8-1));
    
    RGB_matrix(:,:,1) = image_matrix;
    RGB_matrix(:,:,2) = image_matrix;
    RGB_matrix(:,:,3) = image_matrix;

    % red
%     RGB_matrix(:,:,2:3) = 0;

    % green
%     RGB_matrix(:,:,[1 3]) = 0;

    % blue
%     RGB_matrix(:,:,2:3) = 0;


    for cycle_num=2:num_cycles
        for step_num=1:12
            start_x = 1 + (step_num-1)*29;
            start_y_ref = 1 + (cycle_num-2)*29;
            reference_im = image_matrix(start_y_ref:start_y_ref + 28,start_x:start_x + 28);
            start_y_test = 1 + (cycle_num-1)*29;
            test_im = image_matrix(start_y_test:start_y_test + 28,start_x:start_x + 28);
            
            % normalize images
            reference_im = double(reference_im);
            reference_im = reference_im - min(reference_im(:));
            reference_im = reference_im/sum(reference_im(:));

            test_im = double(test_im);
            test_im = test_im - min(test_im(:));
            test_im = test_im/sum(test_im(:));

            % take only 25 for molecule 4
%             diff = 2;
%             reference_im = reference_im(1+diff:end-diff,3:end-diff);
%             test_im = test_im(1+diff:end-diff,3:end-diff);

            % lst sq
            sqs = (test_im - reference_im) .^ 2;
            sm_sqs = sum(sqs(:));

%             disp(sm_sqs);
            good = sm_sqs < 0.0003;

            if good
                ROI_im = double(RGB_matrix(start_y_test:start_y_test + 28,start_x:start_x + 28,:));
                ROI_im(:,:,1) = ROI_im(:,:,1) .* 138/255;
                ROI_im(:,:,2) = ROI_im(:,:,2) .* 244/255;
                ROI_im(:,:,3) = ROI_im(:,:,3) .* 138/255;
%                 RGB_matrix(start_y_test:start_y_test + 28,start_x:start_x + 28,:) = uint8(ROI_im);
            else
%                 RGB_matrix(start_y_test:start_y_test + 28,start_x:start_x + 28,[1]) = 244;
%                 RGB_matrix(start_y_test:start_y_test + 28,start_x:start_x + 28,[2 3]) = 138;
            end

        end
    end

    RGB_matrix = double(RGB_matrix);
    RGB_matrix = RGB_matrix / max(RGB_matrix(:)) * 400;
    RGB_matrix = uint8(RGB_matrix);
    imagesc(ax,RGB_matrix);

    ax.XTick = [];
    ax.YTick = [];



    








