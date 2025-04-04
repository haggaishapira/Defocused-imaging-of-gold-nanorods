

close('all'),clear,clc;

import matlab.io.*

tic

% default_path = 'D:\Sharing\test';
default_path = 'c:\Haggai\Master\AAA_Projects\AAA_Rotor\A_Disk\raw_data_Scattering\test\';
% default_path = 'c:\Haggai\Master\AAA_Projects\AAA_Rotor\A_Disk\raw_data_Scattering\';
[files,pathname] = uigetfile([default_path '\*.fits'], 'Select multiple files','MultiSelect','on');

rand_num = randi(10000,1);
% filename_write = ['vid_' num2str(rand_num)];
num_files = size(files,2);
lengths = zeros(num_files,1);
acc = zeros(num_files,1);

total_len = 0;
acc(1) = 1;

for i=1:num_files
    filename_read = [pathname files{i}];   
    fits_info = fitsinfo(filename_read);
%     keywords = fits_info.PrimaryData.Keywords;
    vid_size = fits_info.PrimaryData.Size;
    vid_len = vid_size(3);    
    lengths(i) = vid_len;
    if i < num_files
        acc(i+1) = acc(i) + vid_len;
    end
        
    total_len = total_len + vid_len;
end
% fclose(f);

% create file
filename_write = [pathname  'combined_1722'];
delete(filename_write);
fptr_write = fits.createFile(['!' filename_write]);
fits.createImg(fptr_write,'int16',[512 512 total_len]);



keywords = fits_info.PrimaryData.Keywords;
num_keys = size(keywords,1);

% fits.writeKey(fptr_write,'SIMPLE','a','b');

% fits.closeFile(fptr_write);
% fitsdisp([filename_write '.fits'],'mode','full');

% return;

for i=7:num_keys
        name = keywords{i,1};
%         disp(name);
    if isempty(keywords{i,2})
        continue;
%         val2 = '0';
    else
        val2 = (keywords{i,2});
    end
    if isempty(keywords{i,3})
        continue;
%         val3 = '0';
    else
        val3 = (keywords{i,3});
    end

    fits.writeKey(fptr_write,name,val2,val3);
%         info = fitsinfo(filename_write);
end

% fptr_read = fits.openFile(filename_read);
% fits.copyHDU(fptr_read,fptr_write)


curr_len = 1;

for i=1:num_files
    filename_read = [pathname files{i}];   
    fits_info = fitsinfo(filename_read);
    
    vid_size = fits_info.PrimaryData.Size;
    vid_len = vid_size(3);
    
%     interval = 100;
%     for j=1:interval:vid_len
%         mx_fr = min(j+interval-1,vid_len);
%         mx_fr = vid_len;
%         curr_vid_len = mx_fr - j + 1;
%         cur_len
        vid = fitsread(filename_read,'PixelRegion',{[1 512],[1 512],[1 vid_len]});
%         vid = fitsread(filename_read,'PixelRegion',{[1 512],[1 512],[1 curr_vid_len]});
%         fr_num = curr_len+j-1;
        vid = uint16(vid);

        fits.writeImg(fptr_write,vid,[curr_len 1 1]);
%         curr_len = curr_len + curr_vid_len;
        curr_len = curr_len + vid_len;
%         disp(j);
%         break;
%     end
%     vid = fitsread(filename_read,'PixelRegion',{[1 512],[1 512],[1 vid_len]});
%     f_read = fopen(filename_read,'r');
%     offset_fits = fits_info.PrimaryData.Offset + 1;
%     fseek(f_read,offset_fits,-1);
%     vid = fread(f_read,512*512*vid_len,'uint16');
% %     vid = reshape(vid,[512 512 vid_len]);
%     vid = vid - 2^15;  
%     vid = imrotate(vid,180);


%     fits.writeImg(fptr_write,vid,[curr_len 1 1]);
    
%     curr_len = curr_len + vid_len;
end

% fptr_read = fits.openFile(filename_read);
% fits.copyHDU(fptr_read,fptr_write)

% num_keys = fits.getHdrSpace(fptr_read);

fits.closeFile(fptr_write);

% fitsdisp([filename_write '.fits'],'mode','full');

toc

