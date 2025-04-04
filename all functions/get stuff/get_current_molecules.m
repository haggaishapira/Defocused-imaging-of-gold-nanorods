function [molecules,num_mol] = get_current_molecules(handles)
    if handles.num_files == 0
        molecules = [];
        num_mol = 0; 
    else
        curr_file = handles.current_file_num;
        analysis = handles.analyses(curr_file);
        molecules = analysis.molecules; 
        num_mol = analysis.num_mol;
    end