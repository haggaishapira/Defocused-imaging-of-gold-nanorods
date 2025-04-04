function handles = connect_piezo(handles)

    try
        addpath (getenv ('PI_MATLAB_DRIVER'));
%         addpath('c:\Program Files (x86)\Physik Instrumente (PI)\Software Suite\');
        Controller = PI_GCS_Controller();
        % devicesUsb = Controller.EnumerateUSB('')
        % controllerSerialNumber = 'E-709.SRG';
        controllerSerialNumber = 'E-709 Digital Piezo Controller SN 0117071741';
        handles.piezo = Controller.ConnectUSB(controllerSerialNumber);
        disp('connected piezo successfully');
%         msgbox('connected piezo successfully');
        handles.piezo_connected_output.String = 'connected';
        handles.piezo_connected_output.BackgroundColor = [0 1 0];

        piezo = handles.piezo;
        min_pos = piezo.qTMN ('1');
        max_pos = piezo.qTMX ('1');
        fprintf('minimum piezo position: %.3f\n',min_pos); 
        fprintf('maximum piezo position: %.3f\n',max_pos); 


        settings = handles.piezo_settings;
        desired_pos = settings.default_z;
        piezo_set_position(piezo,desired_pos);

        display_piezo_position(handles);

    catch e
        disp('error connecting piezo');
        disp(e);
    end


    