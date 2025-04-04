function combined_data = combine_molecule_data(combine_statistics,molecules,num_mol,field,rel_frame,first,last,relative)
    

    if combine_statistics
        % possibly different movie lengths, so need to extract data manually
        % iterate to find length and allocate space
        data_size = 0;
        for i=1:num_mol
    %         num_frames = length(molecules(i).(field));
            len_data = last - first + 1;
            data_size = data_size + len_data;
        end
    
        % allocate
        combined_data = zeros(data_size,1);
    
        % now insert
        counter = 1;
        for i=1:num_mol
            data = molecules(i).(field)(first:last);
            if length(data) > 1
                data = data(first:last);
%                 if relative
%                     rel_data = molecules(i).(field)(rel_frame);
%                     data = data - rel_data;
%                 end
                len_data = length(data);
                combined_data(counter:counter+len_data-1) = data;
            else
                len_data = 1;
                combined_data(counter) = data;
            end
            counter = counter + len_data;
        end
    else
        % movie lengths are the same, just do the normal thing.
        combined_data = cell2mat({molecules.(field)});
    end
    combined_data = double(combined_data);











