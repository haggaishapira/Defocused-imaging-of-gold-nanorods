function ok = step_timeframe_filter(step, first_t, last_t)
    
    ok =  ~(step.start_time < first_t || step.start_time > last_t);

