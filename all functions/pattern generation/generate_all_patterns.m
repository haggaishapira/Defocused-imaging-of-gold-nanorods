function [patterns,focuses] = generate_all_patterns(handles)
    settings = handles.pattern_fitting_settings;

%     nn_array = handles.nn_array;
%     focus_array = get_focus_array(handles);
%     num_focuses = get_num_focuses(handles);
    min_focus = round(settings.min_focus,1);
    max_focus = round(settings.max_focus,1);
    focuses = max_focus:-0.1:min_focus;
    num_focuses = length(focuses);
    max_nn = 14;
    dim = max_nn*2 + 1;

    patterns = zeros(num_focuses,10,72,dim,dim);

    for i=1:num_focuses
        settings.nn = max_nn;
        settings.focus = focuses(i);
        patterns(i,:,:,:,:) = generate_patterns_2(settings);
    end
