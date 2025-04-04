function ok = step_size_filter(settings, step)

    min_step_size = settings.min_step_size;
    max_step_size = settings.max_step_size;

    if step.intermediate
        abs_step_size = step.step_size_1 + step.step_size_2;
    else
        abs_step_size = step.step_size_1;
    end

    ok =  ~(abs_step_size < min_step_size || abs_step_size > max_step_size);

