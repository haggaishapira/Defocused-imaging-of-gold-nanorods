function varargout = gold_rotation(varargin)
% gold_rotation_guide MATLAB code for gold_rotation_guide.fig
%      gold_rotation_guide, by itself, creates a new gold_rotation_guide or raises the existing
%      singleton*.
%
%      H = gold_rotation_guide returns the handle to a new gold_rotation_guide or the handle to
%      the existing singleton*.
%
%      gold_rotation_guide('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in gold_rotation_guide.M with the given input arguments.
%
%      gold_rotation_guide('Property','Value',...) creates a new gold_rotation_guide or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gold_rotation_guide_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gold_rotation_guide_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gold_rotation_guide

% Last Modified by GUIDE v2.5 16-Nov-2023 15:35:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...+
                   'gui_OpeningFcn', @gold_rotation_guide_OpeningFcn, ...
                   'gui_OutputFcn',  @gold_rotation_guide_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before gold_rotation_guide is made visible.
function gold_rotation_guide_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to gold_rotation_guide (see VARARGIN)
    
    handles.figure1.Visible = 'on';
    set(handles.figure1,'MenuBar','figure');
    clc
    % Choose default command line output for gold_rotation_guide
    handles.output = hObject;
    

    handles.current_file_num = 0;
    
    paths = genpath('./all functions');
    addpath(paths);
    
    addpath 'C:\Users\Public\Documents\Matlab\ToolBox\Andor'
    % addpath('c:\Program Files\MATLAB\R2021b\toolbox\Andor');
    
    default_dim = 512;
    default_im = zeros(default_dim,default_dim);
    default_im_ROI = zeros(17,17);
    
    delete(findall(handles.figure1,'type','annotation'));
    % delete(findall(handles.figure1,'type','imrect'));
    % delete(findall(handles.ax_video,'type','imrect'));
    
    handles.registered_positions = [];
    handles.registered_positions_ROIs = [];
    handles.registered_positions_ROI_handles = [];
    
%     handles.registered_phi_states = [];
%     handles.registered_phi_states_curr_mol = [];

    initialize_ax_video(handles,default_dim);

    handles = initialize_polar_axes(handles);
%     handles = initialize_fake_polar_axes(handles);
%     handles.ax_hist_fake_polar.Visible = 'off';
    
    % cla(handles.ax_video);
    cla(handles.ax_ROI);
    cla(handles.ax_trace_sm);
    cla(handles.ax_trace_ensemble);
    
    cla(handles.ax_ROI);
    cla(handles.ax_fitting_pattern);
    cla(handles.ax_3d);
    
    handles.molecule_list.String = {};
    handles.file_list.String = {};
    
    handles.num_mol = 0;
    handles.num_files = 0;
    handles.curr_mol_num = 0;
    
    handles.current_file_num = 0;
        
    min_int = str2num(handles.min_int.String);
    max_int = str2num(handles.max_int.String);
    lims = [min_int max_int];
    % imagesc(default_im,'Parent',handles.ax_video,lims);
    imagesc(default_im_ROI,'Parent',handles.ax_ROI,lims);
    imagesc(default_im_ROI,'Parent',handles.ax_fitting_pattern,[0 0.01]);
    
    [handles.ROI_arrow_reference_main,handles.ROI_arrow_reference_right,handles.ROI_arrow_reference_left] = add_arrow_reference_ROI(handles);
    [handles.ROI_arrow_main,handles.ROI_arrow_right,handles.ROI_arrow_left] = add_arrow_ROI(handles);

    handles.lines_ROI_arrow_reference = ...
        make_lines_array_ROI(handles.ROI_arrow_reference_main,handles.ROI_arrow_reference_right,handles.ROI_arrow_reference_left);
    handles.lines_ROI_arrow = make_lines_array_ROI(handles.ROI_arrow_main,handles.ROI_arrow_right,handles.ROI_arrow_left);

    
    % colormap(handles.ax_video,gray(50));
    colormap(handles.ax_ROI,gray(50));
    colormap(handles.ax_fitting_pattern,gray(50));
    % colormap(handles.ax_angle_frames,gray(50));
    colorbar(handles.ax_video);
    
    pause(0.001); %stupid matlab needs time to update
    handles.default_ax_video_position = handles.ax_video.Position;
    
    
    s1=surf(handles.ax_3d,[0 0;0 0],[0 0;0 0],[0 0;0 0]);
    set(handles.ax_3d,'Xlim',[-40 40],'Ylim',[-40 40],'Zlim',[-40 40],'View',[11.5 8.5]);
    set(s1,'EdgeAlpha',1,'FaceColor',[1 0.8 0]);
    
    set(handles.ax_ROI,'xtick',[]);
    set(handles.ax_3d,'xtick',[]);
    set(handles.ax_fitting_pattern,'xtick',[]);
    % set(handles.ax_angle_frames,'xtick',[]);
    
    set(handles.ax_ROI,'ytick',[]);
    set(handles.ax_3d,'ytick',[]);
    set(handles.ax_fitting_pattern,'ytick',[]);
    % set(handles.ax_angle_frames,'ytick',[]);
    
    set(handles.ax_3d,'ztick',[]);
    
    handles.listener = addlistener(handles.slider_frames, 'Value', 'PreSet',@slider_frames_Callback);       
    handles.listener.Enabled = handles.listener_switch.Value;
      
    disk_6 = Disk(6);
    temp = zeros(25);
    temp(7:19,7:19) = disk_6;
    ring = Disk(12);
    ring(temp > 0) = 0;
    
    handles.original_ring_mask = ring;
    handles.disk = Disk(12);
    
    handles = set_default_analysis_settings(handles);
    handles = set_default_pattern_fitting_settings(handles);
    handles = set_default_acquisition_settings(handles);
    handles = set_default_export_settings(handles);
    handles = set_default_piezo_settings(handles);
    handles = set_default_plot_settings(handles);
    handles = set_default_microfluidics_settings(handles);
    handles = set_default_simulation_settings(handles);
    handles = set_default_general_settings(handles);
    handles = set_default_filter_settings(handles);
    handles = set_default_stage_settings(handles);
    handles = set_default_finding_focus_settings(handles);

    handles = set_default_extra_calculations_settings(handles);

    handles.all_immobilized_mol_plot = [];
    handles.uncrowded_immobilized_mol_plot = [];
%     handles.all_positions_trace = [];
%     handles.total_int = [];
    
    handles.has_analysis = 0;
    
    handles.analysis_mode_setting = 'rotation';
    handles.curr_position_search_method_setting = 'search when focused';

%     handles.pathname.String = 'c:\Haggai\Master\AAA_Projects\AAA_Rotor\A_Disk\raw_data_Scattering\test software - analysis file\';
%     handles.pathname.String = 'D:\scattering data\';
%     handles.pathname.String = 'd:\sharing\Haggai\scattering data\ZZZ_by date\';
%     handles.pathname.String = 'C:\Haggai\Master\AAA_Projects\AAA_Rotor\A_Disk\raw_data_Scattering\test long movies';
%     handles.pathname.String = 'C:\Haggai\acquisition';
%     handles.pathname.String = 'D:\sharing\A_Haggai\A_acquisition';
    handles.pathname.String = 'G:\A_Haggai\A_acquisition';
    
    

    setappdata(0,'acquisition',0);
    
    saved_pat_str = '.\patterns\patterns.mat';  
    if isfile(saved_pat_str)
        saved_patterns = load(saved_pat_str);
        handles.patterns = saved_patterns.saved_patterns.patterns;
        handles.defocuses = saved_patterns.saved_patterns.defocuses;
    else
        [handles.patterns,handles.defocuses] = generate_all_patterns(handles);
        saved_patterns.patterns = handles.patterns;
        saved_patterns.defocuses = handles.defocuses;
        save(saved_pat_str,'saved_patterns');
    end
    % handles.patterns = normalize_patterns(handles.patterns);
    % handles.constraint_fcn = makeConstrainToRectFcn('imrect',[1 512+1],[1 512+1]);
    
    handles.current_plots = {'' '' '' '' ''};
    
    handles.ax_limits = [0 0.01];
    handles.crop_ROI = [1 1 512 512];

    % handles = initialize_camera(handles);
    % gpuDevice;
    handles.piezo = [];
    
    handles.section_size = 100;
    handles.file_id = -1;
    handles.ascending = 1;
    
    % first frame analysis default
    handles.first_t.String = num2str(10); % secs

    handles.sequence_info = [];

    handles.microfluidics_connection = [];
    handles.microfluidics_connected = 0;
    handles = microfluidics_now_disconnected(handles);

    handles.plot_info = [];

    handles.analyses = [];
    handles.file_metadatas = [];
    handles.sequence_infos = [];
    handles.molecule_selections = {};

    handles.curr_mol_num_non_selected = 0;
    handles.curr_mol_num_selected = 0;

    handles.background_green = 0;
    handles.background_red = 0;

    handles.curr_mol_real_num = 0;

    handles.registered_FH12_positions = [];

    handles.area_reference = zeros(512,512);

    handles.batches = [];
    handles.largest_id_num = 0;

    handles.reaction_list = [];
    handles.current_sequence_info = [];

    update_handles(handles.figure1,handles);
    setappdata(0,'stop',0);
    
%     handles.stop_measure = 0;
    setappdata(0,'stop_measuring',0);

    % Update handles structure
    guidata(hObject, handles);
        
    % UIWAIT makes gold_rotation_guide wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gold_rotation_guide_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in display_seq_list.
% hObject    handle to display_seq_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in plot_dwell_times.
function plot_dwell_times_Callback(hObject, eventdata, handles)


% --- Executes on button press in plot_sequence.
function plot_sequence_Callback(hObject, eventdata, handles)
% hObject    handle to plot_sequence (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plot_sequence



function interval_segments_Callback(hObject, eventdata, handles)
% hObject    handle to interval_segments (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of interval_segments as text
%        str2double(get(hObject,'String')) returns contents of interval_segments as a double


% --- Executes during object creation, after setting all properties.
function interval_segments_CreateFcn(hObject, eventdata, handles)
% hObject    handle to interval_segments (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
