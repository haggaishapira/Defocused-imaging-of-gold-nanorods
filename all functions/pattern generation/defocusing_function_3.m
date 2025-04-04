function defocusing_function_3()

f = figure('Visible','on','Position',[250 50 1200 750]);
handles.f = f;

set(f, 'MenuBar',   'none');

handles.ax1 = axes(f, 'Position', [0.3 0.35 0.4 0.6]);
handles.data.image = [];

uicontrol('Style', 'pushbutton', 'String', 'Generate Patterns', 'Position', [120 140 130 40], ...
    'Callback', {@generate_patterns_callback});
handles.stop_search_button = uicontrol('Style', 'pushbutton', 'String', 'Patterns Settings',...
    'Position', [120 90 130 40], 'Callback', {@pattern_settings_callback});


handles.slider_focus = uicontrol('Style','slider','Position', [350 150 500 30],...
                                              'Min',-2,'Max',2,'Value',-1.5,'SliderStep',[1/40 1/40]);
%             'Callback', {@focus_slider_callback}                              
addlistener(handles.slider_focus, 'Value', 'PreSet',@focus_slider_callback);                                          
uicontrol('Style','text','Position', [300 145 50 30],'String','focus');
handles.box_focus = uicontrol('Style','edit','Position', [870 150 50 30]);

handles.slider_theta = uicontrol('Style','slider','Position', [350 100 500 30],...
                                                        'Min',0,'Max',180,'Value',0,'SliderStep',[1/180 1/180]);
addlistener(handles.slider_theta, 'Value', 'PreSet',@theta_slider_callback);                                          
uicontrol('Style','text','Position', [300 95 50 30],'String','theta');
handles.box_theta = uicontrol('Style','edit','Position', [870 100 50 30]);

handles.slider_phi = uicontrol('Style','slider','Position', [350 50 500 30],...
                                                        'Min',0,'Max',360,'Value',0,'SliderStep',[1/360 1/360]);
addlistener(handles.slider_phi, 'Value', 'PreSet',@phi_slider_callback);                                                                                              
uicontrol('Style','text','Position', [300 45 50 30],'String','phi');
handles.box_phi = uicontrol('Style','edit','Position', [870 50 50 30]);

settings = get_default_settings_patterns(handles);
handles.settings.current = settings;
handles.settings.default = settings;

handles.settings.default_index_focus = 1;
handles.settings.default_index_theta = 1;
handles.settings.default_index_phi = 1;

handles.slider_focus.Min = settings(12);
handles.slider_focus.Max = settings(13);
handles.slider_theta.Min = settings(15);
handles.slider_theta.Max = settings(16);
handles.slider_phi.Min = settings(18);
handles.slider_phi.Max = settings(19);

update_handles(f,handles);

function settings = get_default_settings_patterns(handles)    
    z = 0; % the molecule is in the middle of the film lets say. (Doesn't change much)    
    NA = 1.45;
    n0 = 1.52;
    n = 1.35; % PVA    
    n1 = 1.35;
%     d0 = [];
    d = 1e-3; % 20 nm film
%     d1 = [];
    lamem = 0.640;
    mag = 60;
%     atf = [];
%     ring = [];
    pixel = 16/1.6;
    nn = 12;
    block = 3; % in mm
    min_focus = -2;
    max_focus = 2;
    step_focus = 0.25;
    min_theta = 0;
    max_theta = 180;
    step_theta = 30;
    min_phi = 0;
    max_phi = 360;
    step_phi = 30;
    settings = [z, NA, n0, n, n1, d, lamem, mag, pixel, nn, block...
            min_focus,max_focus,step_focus,min_theta,max_theta,step_theta,...
                min_phi,max_phi,step_phi];
    
function update_handles(src,handles)
    guidata(src,handles);
    setappdata(0,'handles',handles);

function show_current_pattern(handles)
    index_focus = handles.current_index_focus;
    index_theta = handles.current_index_theta;
    index_phi = handles.current_index_phi;
    pattern = handles.patterns(index_focus,index_theta,index_phi,:,:);
    pattern = squeeze(pattern);
    imagesc(pattern, 'Parent', handles.ax1);     
    
    
function pattern_settings_callback(src,event)
    handles = guidata(src);
    prompt = {'z','NA','n0','n','n1','d','lamem','mag','pixel','nn','block',...
              'min focus','max focus','step focus',...
              'min theta','max theta','step theta',...
              'min phi','max phi','step_phi'};
    title = 'Simulation Settings';
    dimensions = [1 20];
    default_inputs = num2cell(handles.settings.current);
    for i=1:length(default_inputs)
       cell = default_inputs(i);
       default_inputs(i) = {num2str(cell{1})}; 
    end
    resizable_horizontally = 'on';
    num_col = 2;
    warning ('off','all');
    answer = inputdlgcol(prompt,title,dimensions,default_inputs,resizable_horizontally,num_col);
    warning ('on','all');
    if ~isequal(answer,{})
        for i=1:length(default_inputs)
            cell = answer(i);
            answer(i) = {str2double(cell{1})}; 
        end
        handles.settings.current = cell2mat(answer);
    end
    update_handles(handles.f, handles);
    
function generate_patterns_callback(src,event)
    handles = guidata(src);
    handles = generate_pat(handles);
    show_current_pattern(handles);
    handles.box_focus.String = num2str(handles.settings.current_foci(handles.current_index_focus));
    handles.box_theta.String = num2str(handles.settings.current_thetas(handles.current_index_theta));
    handles.box_phi.String = num2str(handles.settings.current_phis(handles.current_index_phi));
    update_handles(handles.f, handles);
    msgbox('done');
  
function handles = generate_pat(handles)
    settings = handles.settings.current;
    handles.settings.current_foci = settings(12):settings(14):settings(13);
    handles.settings.current_thetas = settings(15):settings(17):settings(16);
    handles.settings.current_phis = settings(18):settings(20):settings(19);
    foci = handles.settings.current_foci;
    thetas = handles.settings.current_thetas*2*pi/360;
    phis = handles.settings.current_phis*2*pi/360;
    handles.patterns = generate_patterns(settings,foci,thetas,phis);
    handles.current_index_focus = handles.settings.default_index_focus;
    handles.current_index_theta = handles.settings.default_index_theta;
    handles.current_index_phi = handles.settings.default_index_phi;
    
function focus_slider_callback(src,event)
    handles = getappdata(0,'handles');
    val = event.AffectedObject.Value; 
    foci = handles.settings.current_foci;
    [m,loc] = min(abs(foci-val));
    if handles.current_index_focus ~= loc  
        handles.current_index_focus = loc;
        handles.box_focus.String = num2str(foci(loc));
        show_current_pattern(handles);
    end
    update_handles(handles.f, handles);
    
function theta_slider_callback(src,event)
    handles = getappdata(0,'handles');
    val = event.AffectedObject.Value; 
    thetas = handles.settings.current_thetas;
    [m,loc] = min(abs(thetas-val));
    if handles.current_index_theta ~= loc  
        handles.current_index_theta = loc;
        handles.box_theta.String = num2str(thetas(loc));
        show_current_pattern(handles);
    end
    update_handles(handles.f, handles);
    
function phi_slider_callback(src,event)
    handles = getappdata(0,'handles');
    val = event.AffectedObject.Value; 
    phis = handles.settings.current_phis;
    [m,loc] = min(abs(phis-val));
    if handles.current_index_phi ~= loc  
        handles.current_index_phi = loc;
        handles.box_phi.String = num2str(phis(loc));
        show_current_pattern(handles);
    end
    update_handles(handles.f, handles);







    
