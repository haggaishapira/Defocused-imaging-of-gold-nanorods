function [new_matrix] = translate_2d(old_matrix,tx,ty)

[y,x] = size(old_matrix);
translated_columns_matrix = zeros(y,x);
new_matrix = zeros(size(old_matrix));

%translate y
for i=1:x
    new_column = translate_1d(old_matrix(:,i),ty);
    translated_columns_matrix(:,i) = new_column';
end

%stretch rows
for i=1:y
    new_row = translate_1d(translated_columns_matrix(i,:),tx);
    new_matrix(i,:) = new_row;
end



    