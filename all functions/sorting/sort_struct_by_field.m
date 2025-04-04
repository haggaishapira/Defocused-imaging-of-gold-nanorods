function sorted_molecules = sort_struct_by_field(molecules, field_num)

    %now the hard part - code taken from matlab forums
    A = molecules;
    Afields = fieldnames(A);
    Acell = struct2cell(A);
    sz = size(Acell);
%     Notice that the this is a 3 dimensional array.
%     Convert to a matrix
    Acell = reshape(Acell, sz(1), []);      % Px(MxN)
    % Make each field a column
    Acell = Acell';                         % (MxN)xP
    % Sort by first field "name"
    Acell = sortrows(Acell, field_num);
       % Put back into original cell array format
    Acell = reshape(Acell', sz);
    % Convert to Struct
    Asorted = cell2struct(Acell, Afields, 1);

    sorted_molecules = Asorted;
%     handles.molecules = Asorted;