function resave_file_descriptor = initialize_resave_file(path_write,width,length)

    

%     tag_struct.Photometric = Tiff.Photometric.MinIsBlack;
%     tag_struct.ImageLength = length;
%     tag_struct.ImageWidth = width;
%     tag_struct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
%     tag_struct.Compression = Tiff.Compression.None;
%     tag_struct.SampleFormat = Tiff.SampleFormat.UInt;
%     tag_struct.BitsPerSample = 16;
%     tag_struct.RowsPerStrip = 512; % http://www.awaresystems.be/imaging/tiff/tifftags/rowsperstrip.html
%     tag_struct.SamplesPerPixel = 1;

%     resave_tif_object = Tiff(path_write, 'w8'); % Big Tiff file

%     tfile.setTag(tag_struct);
