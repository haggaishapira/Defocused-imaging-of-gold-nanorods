
function z_pos = display_piezo_position(handles)

%     piezo = handles.piezo;
    z_pos = handles.piezo.qPOS('1');
%     z_pos = 0;

    str = sprintf('%.3f', z_pos);
    handles.piezo_z_current.String = str;




    