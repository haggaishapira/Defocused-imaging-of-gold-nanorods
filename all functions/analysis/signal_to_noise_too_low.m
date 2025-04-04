function too_low = signal_to_noise_too_low(analysis_settings,S2N)

    S2N_threshold = analysis_settings.S2N_threshold;
    too_low = S2N < S2N_threshold;