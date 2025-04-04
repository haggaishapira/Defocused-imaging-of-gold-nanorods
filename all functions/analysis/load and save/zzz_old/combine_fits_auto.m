function combine_fits_auto(pathname,files, filename_write)

% disp('start combining');
tic

import matlab.io.*

num_files = size(files,2);
lengths = zeros(num_files,1);
acc = zeros(num_files,1);

total_len = 0;
acc(1) = 1;


for i=1:num_files
    filename_read = files{i};
    fits_info = fitsinfo(filename_read);
    vid_size = fits_info.PrimaryData.Size;
    vid_len = vid_size(3);    
    lengths(i) = vid_len;
    if i < num_files
        acc(i+1) = acc(i) + vid_len;
    end
       
    total_len = total_len + vid_len;
end

% create file
fptr_write = fits.createFile(filename_write);
fits.createImg(fptr_write,'int16',[512 512 total_len]);

keywords = fits_info.PrimaryData.Keywords;
num_keys = size(keywords,1);

for i=7:num_keys
        name = keywords{i,1};
    if isempty(keywords{i,2})
        continue;
    else
        val2 = (keywords{i,2});
    end
    if isempty(keywords{i,3})
        continue;
    else
        val3 = (keywords{i,3});
    end
    fits.writeKey(fptr_write,name,val2,val3);
end

curr_len = 1;

for i=1:num_files
    filename_read = files{i};   
    fits_info = fitsinfo(filename_read);
    
    vid_size = fits_info.PrimaryData.Size;
    vid_len = vid_size(3);
    
    f_read = fopen(filename_read,'r');
    offset_fits = fits_info.PrimaryData.Offset + 1;
    fseek(f_read,offset_fits,-1);
    
    vid = fread(f_read,512*512*vid_len,'*uint16');
    fclose(f_read);


    len_read = length(vid);
    len_required = 512*512*vid_len;
    diff = len_required - len_read;
    if diff > 0
       vid = [vid; zeros(diff,1)];
    end
    fprintf('number of missing bytes was %d\n',diff);
    vid = reshape(vid,[512,512,vid_len]);
    vid = vid - 2^15;  
    vid = pagetranspose(vid);
    
    fits.writeImg(fptr_write,vid,[curr_len 1 1]);
    curr_len = curr_len + vid_len;
end

fits.closeFile(fptr_write);
% fitsdisp(filename_write,'mode','full');

toc
% disp('end combining');