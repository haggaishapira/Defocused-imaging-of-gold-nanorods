function [new_array] = translate_1d(old_array,shift)

m = length(old_array);
new_array = zeros(1,m);

for i=1:m
    new_point = i+shift;
    lower = fix(new_point);
    higher = lower+1;
    weight_for_higher = new_point - lower;
    weight_for_lower = 1 - weight_for_higher;
    if lower>=1 & lower<=m 
        new_array(lower) = new_array(lower) + old_array(i)*weight_for_lower;
    end
    if higher>=1 & higher<=m 
        new_array(higher) = new_array(higher) + old_array(i)*weight_for_higher;
    end
end
    



