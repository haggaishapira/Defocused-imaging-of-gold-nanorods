function [img,filename,pathname] = ReadTiff_CP(default_path,filename)

%     ReadTiff(filename, img_first, img_last)
% reads all or parts of a tiff image stack
    img = [];
    if nargin == 1
        filename = [];
    end
    pathname = [];

    if nargin == 1
        default_path = [default_path '/*.tif'];
        [filename,pathname] = uigetfile...
                    (default_path, 'select image file');
        if ~filename
            return;
        end
        full_name = [pathname,filename];
    end
    if ~full_name
        return;
    end
%     if (exist(filename,'file') == 0)
%     %     disp('file not found');
%         no_tif_file = true;
%     e
    

    %check for matfile
%     matfilename = regexprep(filename, '.tif|.stk|.lsm', '.mat');

%     if (exist(matfilename,'file') > 0)
%         % load existing file
%         load(matfilename, 'img');
%         if isempty(img)
%             load(matfilename, 'video');
%             img = video;
%         end
%         
%         img_ifds = size(img, 3);
%     else
        if (exist(full_name,'file') == 0)
            return;
        else
            warning off MATLAB:tifflib:TIFFReadDirectory:libraryWarning;
            ti = Tiff(full_name, 'r');

            % check number of images
            img_ifds = 1;
            while (~ti.lastDirectory())
                ti.nextDirectory();
                img_ifds = img_ifds + 1;
            end
            img_width = ti.getTag('ImageWidth');
            img_length = ti.getTag('ImageLength');

            img = zeros(img_length, img_width, img_ifds,'uint16');
%             img = zeros(img_length, img_width, img_ifds);

            ti.setDirectory(1);
            wait_bar_load = waitbar(0,sprintf('loading %d/%d',0,img_ifds));
    %         wait_bar_load = waitbar(0,'loading');
            if img_ifds == 1
                img = ti.read();
            else
                for i=1:img_ifds
                    if i > 1
                        ti.nextDirectory();
                    end
                    img(:,:,i) = ti.read();
                    if mod(i,100) == 0
                        waitbar(i/img_ifds,wait_bar_load,sprintf('loaded frame %d/%d',i,img_ifds));
                    end
                end
            end
            close(wait_bar_load);
            ti.close();   
%             save(matfilename, 'img');  
        end
%     end
end
