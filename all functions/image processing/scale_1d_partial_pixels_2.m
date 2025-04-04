function new_array = scale_1d_partial_pixels_2(old_array,old_length,new_length)

%old_size is pseudo size, so is new_size
if old_length == new_length
    new_array = old_array;
    return
end

if (old_length <= length(old_array)-1) || (old_length > length(old_array))
    disp('error scale_1d');
    return;
end

m = length(old_array);
n = ceil(new_length);

new_array = zeros(1,n);
factor = new_length/old_length;

if old_length - floor(old_length) > 0
    last = m-1;
else
    last = m;
end
for i=1:last    
    low_point = 1 + (i-1) * factor;
    high_point = 1 + i * factor;
    fraction_low = low_point - floor(low_point);
    fraction_high = high_point - floor(high_point);    
    if floor(high_point) == floor(low_point)
        new_array(floor(low_point)) = new_array(floor(low_point)) + old_array(i);
    else
        if fraction_high>0.01 
            weights = zeros(1, 1 + floor(high_point)-floor(low_point));
            if fraction_low>0
                weights(1) = (1-fraction_low)/factor;
                for j = 2:length(weights)-1
                    weights(j) = 1/factor;
                end
                weights(end) = weights(end) + fraction_high/factor;
            else
                for j = 1:length(weights)-1
                    weights(j) = 1/factor;
                end
                weights(end) = fraction_high/factor;
            end
        else
            weights = zeros(1, 1 + floor(high_point)-floor(low_point) - 1);
            if fraction_low>0
                weights(1) = (1-fraction_low)/factor;
                for j = 2:length(weights)
                    weights(j) = 1/factor;
                end
            else
                for j = 1:length(weights)
                    weights(j) = 1/factor;
                end
            end
        end
        for j=1:length(weights)
            new_array(floor(low_point)+j-1) = new_array(floor(low_point)+j-1) + weights(j)*old_array(i);
        end
    end 
end

if last<m
    diff = old_length - floor(old_length);   
    low_point = 1 + (m-1) * factor;
    high_point = 1+new_length;
    fraction_low = low_point - floor(low_point);
    fraction_high = high_point - floor(high_point);
    if floor(high_point) == floor(low_point)
        new_array(floor(low_point)) = new_array(floor(low_point)) + old_array(m);
    else
        if fraction_high>0
            weights = zeros(1, 1 + floor(high_point)-floor(low_point));
            if fraction_low>0
                weights(1) = (1-fraction_low)/factor/diff;
                for j = 2:length(weights)-1
                    weights(j) = 1/factor/diff;
                end
                weights(end) = weights(end) + fraction_high/factor/diff;
            else
                for j = 1:length(weights)-1
                    weights(j) = 1/factor/diff;
                end
                weights(end) = fraction_high/factor/diff;
            end
        else
            weights = zeros(1, 1 + floor(high_point)-floor(low_point) - 1);
            if fraction_low>0
                weights(1) = (1-fraction_low)/factor/diff;
                for j = 2:length(weights)
                    weights(j) = 1/factor/diff;
                end
            else
                for j = 1:length(weights)
                    weights(j) = 1/factor/diff;
                end
            end
        end
        for j=1:length(weights)
            new_array(floor(low_point)+j-1) = new_array(floor(low_point)+j-1) + weights(j)*old_array(m);
        end
    end
end
end


   






    
