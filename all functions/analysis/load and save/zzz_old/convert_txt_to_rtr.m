
clc

default_path = 'c:\Haggai\Master\A_Rotor\A_Disk\raw_data_Scattering\';
[filename,pathname] = uigetfile([default_path '\*.txt'], 'select image file');
    
final_path = [pathname filename];

[video_size,framerate,gain,molecules] = load_analysis(final_path);

filewrite = [final_path(1:end-3) 'rtr'];

save_analysis_v2(filewrite,video_size,framerate,gain,molecules);

    
    
    
    
    
    
    
    
    
    
    
    
    
    