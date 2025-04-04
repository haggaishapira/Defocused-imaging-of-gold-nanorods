function perform_h2mm(trace)
    settings = [];
    num_states = 3;
    [x_hat,z_hat,returnedErr,errmsg] = vbAnalysis(trace(:),num_states);
    figure
    plot(trace);
    hold on
    plot(x_hat);
