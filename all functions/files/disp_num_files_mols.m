function disp_num_files_mols(handles)
    
    clc
    num_files = handles.num_files;
    num_mols = size(handles.molecule_sets,1);

    fprintf('num_files: %d\n',num_files);
    fprintf('num_mols: %d\n',num_mols);
