function molecule = delete_molecule_display_objects(molecule)
    delete(molecule.arrow_main);
    delete(molecule.arrow_right);
    delete(molecule.arrow_left);
    delete(molecule.ROI_handle);
    delete(molecule.text_num);

    try
        delete(molecule.arrow_main_reference);
        delete(molecule.arrow_right_reference);
        delete(molecule.arrow_left_reference);
    catch e
    end
    

