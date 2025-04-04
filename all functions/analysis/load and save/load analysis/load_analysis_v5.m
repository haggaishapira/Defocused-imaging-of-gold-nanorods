function [molecules,num_mol] = load_analysis_v5(handles,filename,vid_len, framerate)


    f_read = fopen(filename,'r');
    
    for i=1:10
        fgets(f_read);
    end
    num_mol = fscanf(f_read,'number of molecules: %d\n');
    for i=1:3
        fgets(f_read);
    end

    molecules = make_empty_molecules(handles,num_mol, framerate);

    % molecules = [];
    wait_bar = waitbar(0,sprintf('molecule %d/%d', 0,num_mol));
    
    for i=1:num_mol
        molecule = molecules(i);
        molecule.t = fread(f_read,vid_len,'double');
        ROI_flat = fread(f_read,4*vid_len,'int16');
        molecule.ROI = reshape(ROI_flat,[4,vid_len]);
        molecule.back = fread(f_read,vid_len,'int32');
        molecule.int = fread(f_read,vid_len,'int32');
        molecule.theta_half = fread(f_read,vid_len,'int16');
        molecule.phi_half = fread(f_read,vid_len,'int16');
        molecule.theta_whole = fread(f_read,vid_len,'int16');
        molecule.phi_whole = fread(f_read,vid_len,'int16');
        molecule.trace_theta_half = fread(f_read,vid_len,'int16');
        molecule.trace_phi_half = fread(f_read,vid_len,'int16');
        molecule.trace_theta_whole = fread(f_read,vid_len,'int16');
        molecule.trace_phi_whole = fread(f_read,vid_len,'int16');
        molecule.ROI_handle = [];
        molecules(i) = molecule; 
    %     molecules = [molecules molecule];
    %     fscanf(f_read,'\n');
        waitbar(i/num_mol,wait_bar,sprintf('molecule %d/%d', i,num_mol));
    end
    fclose(f_read);
    close(wait_bar);




