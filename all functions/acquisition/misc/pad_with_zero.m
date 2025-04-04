function str = pad_with_zero(str)
    if length(str) == 1
        str = ['0' str];
    end