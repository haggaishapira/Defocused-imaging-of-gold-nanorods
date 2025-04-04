function defocus_array = get_defocus_array(handles)

    nn_array = handles.nn_array;
    defocus_array = nn_array ./ -10;