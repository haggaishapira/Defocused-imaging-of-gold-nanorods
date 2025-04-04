function filtered_molecules = filter_molecules(handles,molecules,num_mol)

    settings = handles.filter_settings;

    % stuck
    min_stuck = settings.min_stuck;
    max_stuck = settings.max_stuck;

    % molecule of interest
    min_molecule_of_interest = settings.min_molecule_of_interest;
    max_molecule_of_interest = settings.max_molecule_of_interest;

    % intensity
    min_int = settings.min_int;
    max_int = settings.max_int;

    % mu
    min_mu = settings.min_mu;
    max_mu = settings.max_mu;

    % sigma
    min_sigma = settings.min_sigma;
    max_sigma = settings.max_sigma;

    % number of matches
%     min_num_matches = settings.min_num_matches;
%     max_num_matches = settings.min_num_matches;
%     max_num_matches = settings.max_num_matches;

    % responds to fuel
%     min_responds_to_fuel = settings.min_responds_to_fuel;
%     max_responds_to_fuel = settings.min_responds_to_fuel;
    min_responds_to_fuel = 0;
    max_responds_to_fuel = 1;

    
    % stuck correct position
    min_stuck_correctly = settings.min_stuck_correctly;
    max_stuck_correctly = settings.max_stuck_correctly;


    filtered_molecules = [];    
    for i=1:num_mol
        stuck = molecules(i).stuck;
        molecule_of_interest = molecules(i).molecule_of_interest;
%         int = max(molecules(i).int);
        int = mean(molecules(i).int);
        mu = molecules(i).phi_dist_mu;
        mu = mod(mu - molecules(i).FH12_position,180);
        
%         sigma = mean(molecules(i).phi_dist_sigma);
        % avg d_phi instead
        sigma = mean(molecules(i).d_phi);
        
%         immob_times = molecules(i).all_immobilization_times;
%         responds_to_fuel = ~isempty(immob_times) && ~isinf(immob_times(1));

%         stuck_correctly = molecules(i).stuck_correctly;
        stuck_correctly = mean(molecules(i).lst_sq_video);
%                responds_to_fuel <= max_responds_to_fuel && responds_to_fuel >= min_responds_to_fuel && ...


        if stuck <= max_stuck && stuck >= min_stuck && ...
               molecule_of_interest <= max_molecule_of_interest && molecule_of_interest >= min_molecule_of_interest && ...
               int <= max_int && int >= min_int && ...
               mu <= max_mu && mu >= min_mu && ...
               sigma <= max_sigma && sigma >= min_sigma && ...
               stuck_correctly <= max_stuck_correctly && stuck_correctly >= min_stuck_correctly
            filtered_molecules = [filtered_molecules molecules(i).num];
        end    
    end
%     num_filtered_mol = size(filtered_molecules,2);
    num_filtered_mol = length(filtered_molecules);
    








