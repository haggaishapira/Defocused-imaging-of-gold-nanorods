function reaction_timings = get_reaction_timings(handles)

    num_cycles = 14;
    start_time = 0;
    duration_mat1 = 1800;
    duration_mat2 = 1800;
    cycle_time = duration_mat1 + duration_mat2;
    reaction_timings.insertion_times_mat1 = start_time + 0:cycle_time:(cycle_time*num_cycles);
    reaction_timings.insertion_times_mat2 = start_time + duration_mat1 + 0:cycle_time:(cycle_time*num_cycles);
    reaction_timings.col_mat1 = 'red';
    reaction_timings.col_mat2 = 'green';


