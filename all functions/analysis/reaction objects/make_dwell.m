function dwell = make_dwell(start_time,end_time,phi)

    dwell.start_time = start_time;
    dwell.end_time = end_time;
    dwell.dwell_time = end_time - start_time;
    dwell.phi = phi;
