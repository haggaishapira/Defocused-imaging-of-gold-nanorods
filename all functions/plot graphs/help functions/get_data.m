function data = get_data(molecules,num_mol,field,first,last,subtract_FH12_pos)
  
    if nargin<6
        subtract_FH12_pos = 0;
    end

    len = last - first + 1;
    data = zeros(len,num_mol);
    for i=1:num_mol
%         datum = molecules(i).(field);
%         data(:,i) = datum(first:min(last,length(datum)));
        data(:,i) = molecules(i).(field)(first:last);
        if subtract_FH12_pos
            data(:,i) = data(:,i) - molecules(i).FH12_position;
        end
    end
    
    