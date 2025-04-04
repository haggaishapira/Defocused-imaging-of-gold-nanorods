function release_reaction = make_release_reaction(start_time,release_time,anti_fuel_number,initial_phi)

    release_reaction.start_time = start_time;
    release_reaction.release_time = release_time;
    release_reaction.relative_release_time = release_time - start_time;
    release_reaction.anti_fuel_number = anti_fuel_number;
    release_reaction.initial_phi = initial_phi;
