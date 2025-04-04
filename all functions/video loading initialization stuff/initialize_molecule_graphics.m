function [handles,analysis] = initialize_molecule_graphics(handles,analysis)
    
    [analysis,handles.all_lines] = add_molecule_arrows_and_numbers(handles, analysis);
    handles = initialize_molecule_list(handles, analysis.molecules);

