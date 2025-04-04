function immobilization_reaction = make_immobilization_reaction(start_time,immobilization_time,fuel_number,final_phi)

    immobilization_reaction.start_time = start_time;
    immobilization_reaction.immobilization_time = immobilization_time;
    immobilization_reaction.relative_immobilization_time = immobilization_time - start_time;
    immobilization_reaction.fuel_number = fuel_number;
    immobilization_reaction.final_phi = final_phi;

